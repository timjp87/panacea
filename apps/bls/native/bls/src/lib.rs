extern crate amcl;
#[macro_use]
extern crate rustler;
extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;
extern crate rand;

use rustler::{Env, Term, NifResult, Encoder};

rustler_export_nifs! {
    "Elixir.Bls",
    [("add", 2, add)],
    None
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

fn add<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let num1: i64 = args[0].decode()?;
    let num2: i64 = args[1].decode()?;

    Ok((atoms::ok(), num1 + num2).encode(env))
}