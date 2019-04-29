extern crate amcl;

use super::amcl_utils::{ate_pairing, hash_on_g2, FP12, GENERATORG1};
use super::errors::DecodeError;
use super::g1::G1Point;
use super::g2::G2Point;
use super::keys::PublicKey;
use super::signature::Signature;

use rustler::{Env, Term, NifResult, Encoder};
use rustler::resource::ResourceArc;

mod atoms {
    rustler_atoms! {
        atom ok;
        atom __false__ = "false";
        atom __true__ = "true";
    }
}

/// Allows for the adding/combining of multiple BLS PublicKeys.
///
/// This may be used to verify some AggregateSignature.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AggregatePublicKey {
    pub point: G1Point,
}

impl AggregatePublicKey {
    /// Instantiate a new aggregate public key.
    ///
    /// The underlying point will be set to infinity.
    pub fn new() -> Self {
        let mut point = G1Point::new();
        // TODO: check why this inf call
        point.inf();
        Self { point }
    }

    pub fn new_nif<'a>(env: Env<'a>, _args: &[Term<'a>]) -> NifResult<Term<'a>> {
        let mut point = G1Point::new();
        // TODO: check why this inf call
        point.inf();
        let agp = ResourceArc::new(AggregatePublicKey{ point });
        Ok((agp).encode(env))
    }

    /// Instantiate a new aggregate public key from a vector of PublicKeys.
    ///
    /// This is a helper method combining the `new()` and `add()` functions.
    pub fn from_public_keys(keys: &[&PublicKey]) -> Self {
        let mut agg_key = AggregatePublicKey::new();
        for key in keys {
            agg_key.add(&key)
        }
        agg_key
    }

    /// Add a PublicKey to the AggregatePublicKey.
    pub fn add(&mut self, public_key: &PublicKey) {
        self.point.add(&public_key.point);
        self.point.affine();
    }

    /// Add a AggregatePublicKey to the AggregatePublicKey.
    pub fn add_aggregate(&mut self, aggregate_public_key: &AggregatePublicKey) {
        self.point.add(&aggregate_public_key.point);
        self.point.affine();
    }

    /// Instantiate an AggregatePublicKey from compressed bytes.
    pub fn from_bytes(bytes: &[u8]) -> Result<AggregatePublicKey, DecodeError> {
        let point = G1Point::from_bytes(bytes)?;
        Ok(Self { point })
    }

    /// Export the AggregatePublicKey to compressed bytes.
    pub fn as_bytes(&self) -> Vec<u8> {
        let mut clone = self.point.clone();
        clone.as_bytes()
    }
}

impl Default for AggregatePublicKey {
    fn default() -> Self {
        Self::new()
    }
}

/// Allows for the adding/combining of multiple BLS Signatures.
///
/// This may be verified against some AggregatePublicKey.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AggregateSignature {
    pub point: G2Point,
}

impl AggregateSignature {
    /// Instantiates a new AggregateSignature.
    ///
    /// The underlying point will be set to infinity.
    pub fn new() -> Self {
        let mut point = G2Point::new();
        point.inf();
        Self { point }
    }
    
    /// Exportable NIF
    pub fn new_nif<'a>(env: Env<'a>, _args: &[Term<'a>]) -> NifResult<Term<'a>> {
        let mut point = G2Point::new();
        point.inf();
        let asig = ResourceArc::new(AggregateSignature { point });
        Ok((asig).encode(env))
    }

    /// Add a Signature to the AggregateSignature.
    pub fn add(&mut self, signature: &Signature) {
        self.point.add(&signature.point);
        self.point.affine();
    }

    /// Add a Signature to the AggregateSignature.
    // pub fn add_nif<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    //     let asig: ResourceArc<AggregateSignature> = args[0].decode()?;
    //     let sig: ResourceArc<Signature> = args[1].decode()?;
    //     asig.point.add(&sig.point);
    //     asig.point.affine();
    //     Ok((atoms::ok()).encode(env))
    // }

    /// Add a AggregateSignature to the AggregateSignature.
    pub fn add_aggregate(&mut self, aggregate_signature: &AggregateSignature) {
        self.point.add(&aggregate_signature.point);
        self.point.affine();
    }

    /// Verify this AggregateSignature against an AggregatePublicKey.
    ///
    /// All PublicKeys which signed across this AggregateSignature must be included in the
    /// AggregatePublicKey, otherwise verification will fail.
    pub fn verify(&self, msg: &[u8], d: u64, avk: &AggregatePublicKey) -> bool {
        let mut sig_point = self.point.clone();
        let mut key_point = avk.point.clone();
        sig_point.affine();
        key_point.affine();
        let mut msg_hash_point = hash_on_g2(msg, d);
        msg_hash_point.affine();
        let mut lhs = ate_pairing(sig_point.as_raw(), &GENERATORG1);
        let mut rhs = ate_pairing(&msg_hash_point, &key_point.as_raw());
        lhs.equals(&mut rhs)
    }

    // Exportable verify.
    pub fn verify_nif<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
        let asig: ResourceArc<AggregateSignature> = args[0].decode()?;
        let msg: Vec<u8> = args[1].decode()?;
        let d: u64 = args[2].decode()?;
        let agpk: ResourceArc<AggregatePublicKey> = args[3].decode()?; 
        let mut sig_point = asig.point.clone();
        let mut key_point = agpk.point.clone();
        sig_point.affine();
        key_point.affine();
        let mut msg_hash_point = hash_on_g2(&msg, d);
        msg_hash_point.affine();
        let mut lhs = ate_pairing(sig_point.as_raw(), &GENERATORG1);
        let mut rhs = ate_pairing(&msg_hash_point, &key_point.as_raw());
        match lhs.equals(&mut rhs) {
            true => Ok((atoms::__true__()).encode(env)),
            false => Ok((atoms::__false__()).encode(env)),
        }
    }

    /// Verify this AggregateSignature against multiple AggregatePublickeys with multiple Messages.
    ///
    ///  All PublicKeys related to a Message should be aggregated into one AggregatePublicKey.
    ///  Each AggregatePublicKey has a 1:1 ratio with a 32 byte Message.
    pub fn verify_multiple(&self, msg: &[u8], d: u64, avks: &[&AggregatePublicKey]) -> bool {
        let mut sig_point = self.point.clone();
        sig_point.affine();

        // Messages are 32 bytes and need a 1:1 ratio to AggregatePublicKeys
        if msg.len() != 32 * avks.len() || avks.is_empty() {
            return false;
        }

        // Aggregate each AggregatePublicKey with a Message
        let mut lhs = FP12::new();
        for (i, key) in avks.iter().enumerate() {
            let mut key_point = key.point.clone();
            key_point.affine();
            let mut hash_point = hash_on_g2(&msg[i * 32..(i + 1) * 32], d);
            hash_point.affine();
            let pair = ate_pairing(&hash_point, key_point.as_raw());
            if i == 0 {
                lhs = pair;
            } else {
                lhs.mul(&pair);
            }
        }

        let mut rhs = ate_pairing(sig_point.as_raw(), &GENERATORG1);
        lhs.equals(&mut rhs)
    }

    /// Instatiate an AggregateSignature from some bytes.
    pub fn from_bytes(bytes: &[u8]) -> Result<AggregateSignature, DecodeError> {
        let point = G2Point::from_bytes(bytes)?;
        Ok(Self { point })
    }

    /// Export (serialize) the AggregateSignature to bytes.
    pub fn as_bytes(&self) -> Vec<u8> {
        let mut clone = self.point.clone();
        clone.as_bytes()
    }

    /// NIF Export (serialize) the AggregateSignature to bytes.
    pub fn as_bytes_nif<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
        let asig: ResourceArc<AggregateSignature> = args[0].decode()?;
        let mut clone = asig.point.clone();
        Ok((clone.as_bytes()).encode(env))
    }
}

impl Default for AggregateSignature {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    extern crate hex;
    extern crate yaml_rust;

    use self::yaml_rust::yaml;
    use super::super::keys::{Keypair, SecretKey};
    use super::*;
    use std::{fs::File, io::prelude::*, path::PathBuf};

    #[test]
    fn test_aggregate_serialization() {
        let signing_secret_key_bytes = vec![
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 161, 50, 32, 254, 87, 16, 25,
                167, 79, 192, 116, 176, 74, 164, 217, 40, 57, 179, 15, 19, 21, 240, 100, 70, 127,
                111, 170, 129, 137, 42, 53,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 72, 211, 104, 184, 68, 142,
                208, 115, 22, 156, 97, 28, 216, 228, 102, 4, 218, 116, 226, 166, 131, 67, 7, 40,
                55, 157, 167, 157, 127, 143, 13,
            ],
        ];
        let signing_keypairs: Vec<Keypair> = signing_secret_key_bytes
            .iter()
            .map(|bytes| {
                let sk = SecretKey::from_bytes(&bytes).unwrap();
                let pk = PublicKey::from_secret_key(&sk);
                Keypair { sk, pk }
            })
            .collect();

        let message = "cats".as_bytes();
        let domain = 42;

        let mut agg_sig = AggregateSignature::new();
        let mut agg_pub_key = AggregatePublicKey::new();
        for keypair in &signing_keypairs {
            let sig = Signature::new(&message, domain, &keypair.sk);
            agg_sig.add(&sig);
            agg_pub_key.add(&keypair.pk);
        }

        let agg_sig_bytes = agg_sig.as_bytes();
        let agg_pub_bytes = agg_pub_key.as_bytes();

        let agg_sig = AggregateSignature::from_bytes(&agg_sig_bytes).unwrap();
        let agg_pub_key = AggregatePublicKey::from_bytes(&agg_pub_bytes).unwrap();

        assert!(agg_sig.verify(&message, domain, &agg_pub_key));
    }

    fn map_secret_bytes_to_keypairs(secret_key_bytes: Vec<Vec<u8>>) -> Vec<Keypair> {
        let mut keypairs = vec![];
        for bytes in secret_key_bytes {
            let sk = SecretKey::from_bytes(&bytes).unwrap();
            let pk = PublicKey::from_secret_key(&sk);
            keypairs.push(Keypair { sk, pk })
        }
        keypairs
    }

    /// A helper for doing a comprehensive aggregate sig test.
    fn helper_test_aggregate_public_keys(
        control_kp: Keypair,
        signing_kps: Vec<Keypair>,
        non_signing_kps: Vec<Keypair>,
    ) {
        let signing_kps_subset = {
            let mut subset = vec![];
            for i in 0..signing_kps.len() - 1 {
                subset.push(signing_kps[i].clone());
            }
            subset
        };

        let messages = vec![
            "Small msg".as_bytes(),
            "cats lol".as_bytes(),
            &[42_u8; 133700],
        ];
        let domain = 42;

        for message in messages {
            let mut agg_signature = AggregateSignature::new();
            let mut signing_agg_pub = AggregatePublicKey::new();
            for keypair in &signing_kps {
                let sig = Signature::new(&message, domain, &keypair.sk);
                assert!(sig.verify(&message, domain, &keypair.pk));
                assert!(!sig.verify(&message, domain, &control_kp.pk));
                agg_signature.add(&sig);
                signing_agg_pub.add(&keypair.pk);
            }

            /*
             * The full set of signed keys should pass verification.
             */
            assert!(agg_signature.verify(&message, domain, &signing_agg_pub));

            /*
             * The full set of signed keys aggregated in reverse order
             * should pass verification.
             */
            let mut rev_signing_agg_pub = AggregatePublicKey::new();
            for i in (0..signing_kps.len()).rev() {
                rev_signing_agg_pub.add(&signing_kps[i].pk);
            }
            assert!(agg_signature.verify(&message, domain, &rev_signing_agg_pub));

            /*
             * The full set of signed keys aggregated in non-sequential
             * order should pass verification.
             *
             * Note: "shuffled" is used loosely here: we split the vec of keys in half, put
             * the last half in front of the first half and then swap the first and last elements.
             */
            let mut shuffled_signing_agg_pub = AggregatePublicKey::new();
            let n = signing_kps.len();
            assert!(
                n > 2,
                "test error: shuffle is ineffective with less than two elements"
            );
            let mut order: Vec<usize> = ((n / 2)..n).collect();
            order.append(&mut (0..(n / 2)).collect());
            order.swap(0, n - 1);
            for i in order {
                shuffled_signing_agg_pub.add(&signing_kps[i].pk);
            }
            assert!(agg_signature.verify(&message, domain, &shuffled_signing_agg_pub));

            /*
             * The signature should fail if an signing key has double-signed the
             * aggregate signature.
             */
            let mut double_sig_agg_sig = agg_signature.clone();
            let extra_sig = Signature::new(&message, domain, &signing_kps[0].sk);
            double_sig_agg_sig.add(&extra_sig);
            assert!(!double_sig_agg_sig.verify(&message, domain, &signing_agg_pub));

            /*
             * The full set of signed keys should fail verification if one key signs across a
             * different message.
             */
            let mut distinct_msg_agg_sig = AggregateSignature::new();
            let mut distinct_msg_agg_pub = AggregatePublicKey::new();
            for (i, kp) in signing_kps.iter().enumerate() {
                let message = match i {
                    0 => "different_msg!1".as_bytes(),
                    _ => message,
                };
                let sig = Signature::new(&message, domain, &kp.sk);
                distinct_msg_agg_sig.add(&sig);
                distinct_msg_agg_pub.add(&kp.pk);
            }
            assert!(!distinct_msg_agg_sig.verify(&message, domain, &distinct_msg_agg_pub));

            /*
             * The signature should fail if an extra, non-signing key has signed the
             * aggregate signature.
             */
            let mut super_set_agg_sig = agg_signature.clone();
            let extra_sig = Signature::new(&message, domain, &non_signing_kps[0].sk);
            super_set_agg_sig.add(&extra_sig);
            assert!(!super_set_agg_sig.verify(&message, domain, &signing_agg_pub));

            /*
             * A subset of signed keys should fail verification.
             */
            let mut subset_pub_keys: Vec<&PublicKey> =
                signing_kps_subset.iter().map(|kp| &kp.pk).collect();
            let subset_agg_key = AggregatePublicKey::from_public_keys(&subset_pub_keys.as_slice());
            assert!(!agg_signature.verify(&message, domain, &subset_agg_key));
            // Sanity check the subset test by completing the set and verifying it.
            subset_pub_keys.push(&signing_kps[signing_kps.len() - 1].pk);
            let subset_agg_key = AggregatePublicKey::from_public_keys(&subset_pub_keys);
            assert!(agg_signature.verify(&message, domain, &subset_agg_key));

            /*
             * A set of keys which did not sign the message at all should fail
             */
            let mut non_signing_pub_keys: Vec<&PublicKey> =
                non_signing_kps.iter().map(|kp| &kp.pk).collect();
            let non_signing_agg_key =
                AggregatePublicKey::from_public_keys(&non_signing_pub_keys.as_slice());
            assert!(!agg_signature.verify(&message, domain, &non_signing_agg_key));

            /*
             * An empty aggregate pub key (it has not had any keys added to it) should
             * fail.
             */
            let empty_agg_pub = AggregatePublicKey::new();
            assert!(!agg_signature.verify(&message, domain, &empty_agg_pub));
        }
    }

    #[test]
    fn test_random_aggregate_public_keys() {
        let control_kp = Keypair::random();
        let signing_kps = vec![
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
        ];
        let non_signing_kps = vec![
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
            Keypair::random(),
        ];
        helper_test_aggregate_public_keys(control_kp, signing_kps, non_signing_kps);
    }

    #[test]
    fn test_known_aggregate_public_keys() {
        let control_secret_key_bytes = vec![vec![
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 129, 16, 229, 203, 159, 171, 37,
            94, 38, 3, 24, 17, 213, 243, 246, 122, 105, 202, 156, 186, 237, 54, 148, 116, 130, 20,
            138, 15, 134, 45, 73,
        ]];
        let control_kps = map_secret_bytes_to_keypairs(control_secret_key_bytes);
        let control_kp = control_kps[0].clone();
        let signing_secret_key_bytes = vec![
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 161, 50, 32, 254, 87, 16, 25,
                167, 79, 192, 116, 176, 74, 164, 217, 40, 57, 179, 15, 19, 21, 240, 100, 70, 127,
                111, 170, 129, 137, 42, 53,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 72, 211, 104, 184, 68, 142,
                208, 115, 22, 156, 97, 28, 216, 228, 102, 4, 218, 116, 226, 166, 131, 67, 7, 40,
                55, 157, 167, 157, 127, 143, 13,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 94, 157, 163, 128, 239, 119, 116,
                194, 162, 172, 189, 100, 36, 33, 13, 31, 137, 177, 80, 73, 119, 126, 246, 215, 123,
                178, 195, 12, 141, 65, 65, 89,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 195, 255, 195, 62, 36, 197, 48,
                100, 25, 121, 8, 191, 219, 73, 136, 227, 203, 98, 123, 204, 27, 197, 66, 193, 107,
                115, 53, 5, 98, 137, 77,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 16, 65, 222, 228, 32, 47, 1,
                245, 135, 169, 125, 46, 120, 57, 149, 121, 254, 168, 52, 30, 221, 150, 186, 157,
                141, 25, 143, 175, 196, 21, 176,
            ],
        ];
        let signing_kps = map_secret_bytes_to_keypairs(signing_secret_key_bytes);
        let non_signing_secret_key_bytes = vec![
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 235, 126, 159, 58, 82, 170, 175,
                73, 188, 251, 60, 79, 24, 164, 146, 88, 210, 177, 65, 62, 183, 124, 129, 109, 248,
                181, 29, 16, 128, 207, 23,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 177, 235, 229, 217, 215, 204,
                237, 178, 196, 182, 51, 28, 147, 58, 24, 79, 134, 41, 185, 153, 133, 229, 195, 32,
                221, 247, 171, 91, 196, 65, 250,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 154, 236, 86, 178, 14, 179,
                117, 113, 4, 40, 173, 150, 221, 23, 7, 117, 162, 173, 104, 172, 241, 111, 31, 170,
                241, 185, 31, 69, 164, 115, 126,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 67, 192, 157, 69, 188, 53, 161,
                77, 187, 133, 49, 254, 165, 47, 189, 185, 150, 23, 231, 143, 31, 64, 208, 134, 147,
                53, 53, 228, 225, 104, 62,
            ],
            vec![
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 66, 26, 11, 101, 38, 37, 1,
                148, 156, 162, 211, 37, 231, 37, 222, 172, 36, 224, 218, 187, 127, 122, 195, 229,
                234, 124, 91, 246, 73, 12, 120,
            ],
        ];
        let non_signing_kps = map_secret_bytes_to_keypairs(non_signing_secret_key_bytes);
        helper_test_aggregate_public_keys(control_kp, signing_kps, non_signing_kps);
    }

    #[test]
    pub fn test_verify_multiple_true() {
        let domain = 45 as u64;
        let mut msg_1: Vec<u8> = vec![111; 32];
        let mut msg_2: Vec<u8> = vec![222; 32];

        // To form first AggregatePublicKey (and sign messages)
        let mut aggregate_signature = AggregateSignature::new();
        let keypair_1 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_1.sk));
        let keypair_2 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_2.sk));
        let keypair_3 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_3.sk));
        let apk_1 =
            AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk, &keypair_3.pk]);
        // Verify with one AggregateSignature and Message (same functionality as AggregateSignature::verify())
        assert!(aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1]));

        // To form second AggregatePublicKey (and sign messages)
        let keypair_1 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_1.sk));
        let keypair_2 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_2.sk));
        let keypair_3 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_3.sk));
        let apk_2 =
            AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk, &keypair_3.pk]);

        msg_1.append(&mut msg_2);
        let apks = [&apk_1, &apk_2];
        assert!(aggregate_signature.verify_multiple(&msg_1, domain, &apks));
    }

    #[test]
    #[ignore]
    pub fn test_verify_multiple_true_large() {
        // Testing large number of PublicKeys
        // Default to ignore as this takes about 10mins
        let domain = 45;
        let mut msg_1: Vec<u8> = vec![11; 32];
        let mut msg_2: Vec<u8> = vec![22; 32];
        let mut aggregate_signature = AggregateSignature::new();
        let mut apk_1 = AggregatePublicKey::new();
        let mut apk_2 = AggregatePublicKey::new();
        for _ in 0..1024 {
            let key_1 = Keypair::random();
            let key_2 = Keypair::random();
            apk_1.add(&key_1.pk);
            apk_2.add(&key_2.pk);
            aggregate_signature.add(&Signature::new(&msg_1, domain, &key_1.sk));
            aggregate_signature.add(&Signature::new(&msg_2, domain, &key_2.sk));
        }

        msg_1.append(&mut msg_2);
        assert!(aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1, &apk_2]));
    }

    #[test]
    pub fn test_verify_multiple_false() {
        let domain = 45 as u64;
        let mut msg_1: Vec<u8> = vec![111; 32];
        let mut msg_2: Vec<u8> = vec![222; 32];

        // To form first AggregatePublicKey (and sign messages)
        let mut aggregate_signature = AggregateSignature::new();
        let keypair_1 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_1.sk));
        let keypair_2 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_2.sk));
        let keypair_3 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_1, domain, &keypair_3.sk));

        // Too few public keys
        let apk_1 = AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk]);
        assert!(!aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1]));

        // Too many public keys
        let apk_1 = AggregatePublicKey::from_public_keys(&[
            &keypair_1.pk,
            &keypair_2.pk,
            &keypair_3.pk,
            &keypair_3.pk,
        ]);
        assert!(!aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1]));

        // Signature does not match message
        let apk_1 =
            AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk, &keypair_3.pk]);
        assert!(!aggregate_signature.verify_multiple(&msg_2, domain, &[&apk_1]));

        // Too many AgregatePublicKeys
        assert!(!aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1, &apk_1]));

        // Incorrect domain
        assert!(!aggregate_signature.verify_multiple(&msg_1, 46, &[&apk_1]));

        // To form second AggregatePublicKey and second Message
        msg_2.push(222); // msg_2 now 33 bytes
        let keypair_1 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_1.sk));
        let keypair_2 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_2.sk));
        let keypair_3 = Keypair::random();
        aggregate_signature.add(&Signature::new(&msg_2, domain, &keypair_3.sk));
        let apk_2 =
            AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk, &keypair_3.pk]);
        msg_1.append(&mut msg_2);
        let apks = [&apk_1, &apk_2];

        // Messages 2 is too long even though signed appropriately
        assert!(!aggregate_signature.verify_multiple(&msg_1, domain, &apks));

        // Message 2 is correct length but has not been signed correctly
        msg_1.pop();
        assert!(!aggregate_signature.verify_multiple(&msg_1, domain, &[&apk_1, &apk_2]));
    }

    #[test]
    pub fn case06_aggregate_sigs() {
        // Run tests from test_bls.yml
        let mut file = {
            let mut file_path_buf = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
            file_path_buf.push("src/test_vectors/test_bls.yml");

            File::open(file_path_buf).unwrap()
        };
        let mut yaml_str = String::new();
        file.read_to_string(&mut yaml_str).unwrap();
        let docs = yaml::YamlLoader::load_from_str(&yaml_str).unwrap();
        let doc = &docs[0];

        // Select test case06
        let test_cases = doc["case06_aggregate_sigs"].as_vec().unwrap();

        // Verify input against output for each pair
        for test_case in test_cases {
            // Convert input to rust formats
            let mut aggregate_sig = AggregateSignature::new();
            let inputs = test_case["input"].clone();

            // Add each input signature to the aggregate signature
            for input in inputs {
                let sig = input.as_str().unwrap().trim_start_matches("0x"); // String
                let sig = hex::decode(sig).unwrap(); // Bytes
                let sig = Signature::from_bytes(&sig).unwrap(); // Signature
                aggregate_sig.add(&sig);
            }

            // Verfiry aggregate signature matches output
            let output = test_case["output"]
                .as_str()
                .unwrap()
                .trim_start_matches("0x"); // String
            let output = hex::decode(output).unwrap(); // Bytes

            assert_eq!(aggregate_sig.as_bytes(), output);
        }
    }

    #[test]
    pub fn case07_aggregate_pubkeys() {
        // Run tests from test_bls.yml
        let mut file = {
            let mut file_path_buf = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
            file_path_buf.push("src/test_vectors/test_bls.yml");

            File::open(file_path_buf).unwrap()
        };
        let mut yaml_str = String::new();
        file.read_to_string(&mut yaml_str).unwrap();
        let docs = yaml::YamlLoader::load_from_str(&yaml_str).unwrap();
        let doc = &docs[0];

        // Select test case07
        let test_case = doc["case07_aggregate_pubkeys"].clone();

        // Convert input to rust formats
        let mut aggregate_pk = AggregatePublicKey::new();
        let inputs = test_case[0]["input"].clone();

        // Add each input PublicKey to AggregatePublicKey
        for input in inputs {
            let pk = input.as_str().unwrap().trim_start_matches("0x"); // String
            let pk = hex::decode(pk).unwrap(); // Bytes
            let pk = PublicKey::from_bytes(&pk).unwrap(); // PublicKey
            aggregate_pk.add(&pk);
        }

        // Verfiry AggregatePublicKey matches output
        let output = test_case[0]["output"]
            .as_str()
            .unwrap()
            .trim_start_matches("0x"); // String
        let output = hex::decode(output).unwrap(); // Bytes

        assert_eq!(aggregate_pk.as_bytes(), output);
    }

    #[test]
    pub fn add_aggregate_public_key() {
        let keypair_1 = Keypair::random();
        let keypair_2 = Keypair::random();
        let keypair_3 = Keypair::random();
        let keypair_4 = Keypair::random();

        let aggregate_public_key12 =
            AggregatePublicKey::from_public_keys(&[&keypair_1.pk, &keypair_2.pk]);

        let aggregate_public_key34 =
            AggregatePublicKey::from_public_keys(&[&keypair_3.pk, &keypair_4.pk]);

        // Should be the same as adding two aggregates
        let aggregate_public_key1234 = AggregatePublicKey::from_public_keys(&[
            &keypair_1.pk,
            &keypair_2.pk,
            &keypair_3.pk,
            &keypair_4.pk,
        ]);

        // Aggregate AggregatePublicKeys
        let mut add_aggregate_public_key = AggregatePublicKey::new();
        add_aggregate_public_key.add_aggregate(&aggregate_public_key12);
        add_aggregate_public_key.add_aggregate(&aggregate_public_key34);

        assert_eq!(add_aggregate_public_key, aggregate_public_key1234);
    }

    #[test]
    pub fn add_aggregate_signature() {
        let domain = 45 as u64;
        let msg: Vec<u8> = vec![1; 32];

        let keypair_1 = Keypair::random();
        let keypair_2 = Keypair::random();
        let keypair_3 = Keypair::random();
        let keypair_4 = Keypair::random();

        let sig_1 = Signature::new(&msg, domain, &keypair_1.sk);
        let sig_2 = Signature::new(&msg, domain, &keypair_2.sk);
        let sig_3 = Signature::new(&msg, domain, &keypair_3.sk);
        let sig_4 = Signature::new(&msg, domain, &keypair_4.sk);

        // Should be the same as adding two aggregates
        let aggregate_public_key = AggregatePublicKey::from_public_keys(&[
            &keypair_1.pk,
            &keypair_2.pk,
            &keypair_3.pk,
            &keypair_4.pk,
        ]);

        let mut aggregate_signature = AggregateSignature::new();
        aggregate_signature.add(&sig_1);
        aggregate_signature.add(&sig_2);
        aggregate_signature.add(&sig_3);
        aggregate_signature.add(&sig_4);

        let mut add_aggregate_signature = AggregateSignature::new();
        add_aggregate_signature.add(&sig_1);
        add_aggregate_signature.add(&sig_2);

        let mut aggregate_signature34 = AggregateSignature::new();
        aggregate_signature34.add(&sig_3);
        aggregate_signature34.add(&sig_4);

        add_aggregate_signature.add_aggregate(&aggregate_signature34);

        add_aggregate_signature.point.affine();
        aggregate_signature.point.affine();

        assert_eq!(add_aggregate_signature, aggregate_signature);
        assert!(add_aggregate_signature.verify(&msg, domain, &aggregate_public_key));
    }
}
