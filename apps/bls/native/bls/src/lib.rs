extern crate amcl;
#[macro_use]
extern crate rustler;
extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;
extern crate rand;

use rustler::{Env, Term};

rustler_export_nifs! {
    "Elixir.Bls",
    [
    ("new_kp", 0, Keypair::random),
    ("sign", 3, Signature::new)
    ],
    Some(on_load)
}

fn on_load(env: Env, _info: Term) -> bool {
    resource_struct_init!(PublicKey, env);
    resource_struct_init!(SecretKey, env);
    resource_struct_init!(Signature, env);
    resource_struct_init!(Keypair, env);
    resource_struct_init!(AggregatePublicKey, env);
    resource_struct_init!(AggregateSignature, env);
    true
}

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}
mod aggregates;
mod amcl_utils;
mod errors;
mod g1;
mod g2;
mod keys;
mod rng;
mod signature;

use self::amcl::bls381 as BLSCurve;

pub use aggregates::{AggregatePublicKey, AggregateSignature};
pub use errors::DecodeError;
pub use keys::{Keypair, PublicKey, SecretKey};
pub use signature::Signature;