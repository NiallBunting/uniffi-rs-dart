/* This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use crate::{
    bindings::{RunScriptOptions, TargetLanguage},
    library_mode::generate_bindings,
};
use anyhow::{Context, Result};
use camino::Utf8Path;
use std::process::Command;
use uniffi_testing::UniFFITestHelper;

/// Run Dart tests for a UniFFI test fixture
pub fn run_test(tmp_dir: &str, fixture_name: &str, script_file: &str) -> Result<()> {
    run_script(
        tmp_dir,
        fixture_name,
        script_file,
        vec![],
        &RunScriptOptions::default(),
    )
}

/// Run a Dart script
///
/// This function will set things up so that the script can import the UniFFI bindings for a crate
pub fn run_script(
    tmp_dir: &str,
    crate_name: &str,
    script_file: &str,
    args: Vec<String>,
    _options: &RunScriptOptions,
) -> Result<()> {
    let script_path = Utf8Path::new(".").join(script_file).canonicalize_utf8()?;
    let test_helper = UniFFITestHelper::new(crate_name)?;
    let out_dir = test_helper.create_out_dir(tmp_dir, &script_path)?;
    let cdylib_path = test_helper.copy_cdylib_to_out_dir(&out_dir)?;
    generate_bindings(
        &cdylib_path,
        None,
        &[TargetLanguage::Dart],
        &out_dir,
        false,
    )?;

    let mut command = Command::new("dart run");
    command
        .current_dir(out_dir)
        .arg(script_path)
        .args(args);
    let status = command
        .spawn()
        .context("Failed to spawn `dart` when running script")?
        .wait()
        .context("Failed to wait for `dart` when running script")?;
    if !status.success() {
        anyhow::bail!("running `dart` failed");
    }
    Ok(())
}
