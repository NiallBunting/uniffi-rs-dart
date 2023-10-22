/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use std::process::Command;

use anyhow::Result;
use camino::Utf8Path;
use fs_err as fs;

pub mod gen_dart;
mod test;
use super::super::interface::ComponentInterface;
pub use gen_dart::{generate_dart_bindings, Config};
pub use test::{run_script, run_test};

// Generate python bindings for the given ComponentInterface, in the given output directory.
pub fn write_bindings(
    config: &Config,
    ci: &ComponentInterface,
    out_dir: &Utf8Path,
    try_format_code: bool,
) -> Result<()> {
    let dart_file = out_dir.join(format!("{}.dart", ci.namespace()));
    fs::write(&dart_file, generate_dart_bindings(config, ci)?)?;

    if try_format_code {
        if let Err(e) = Command::new("dart format").arg(&dart_file).output() {
            println!(
                "Warning: Unable to auto-format {} using dart format: {e:?}",
                dart_file.file_name().unwrap(),
            )
        }
    }

    Ok(())
}
