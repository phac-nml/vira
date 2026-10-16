# phac-nml/vira: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2026-10-09

Small update linking in SARS-CoV-2 pangolin results to the final report as an example of virus specific process work

### `Changed`

- Pangolin overall `lineage_report.csv` file is now created and written to `<outdir>/pangolin` [(PR #31)](https://github.com/phac-nml/vira/pull/31)
  - The lineage and assignment database version are also written to the final CSV file

## [2.0.0] - 2026-10-07

A complete restructuring of the entire pipeline including a name change from `ViralAssembly` to `VIRA` to mark the release! This major update includes a complete overhaul of the pipeline workflow, adds support for Illumina sequencing, updates variant and minor-variant analysis workflows, adds virus-specific downstream analyses (with more to come), and improves quality control and reporting outputs. Top-level summaries of changes are shown below in the CHANGELOG. Please review the pipeline's [documents directory](./docs/) for in-depth information on [running the pipeline](./docs/usage.md) and [the expected outputs](./docs/output.md) as there have been a large number of changes. [Example commands](./docs/example_commands.md) are also available to get started with.

### `Added`

- Addition of an Illumina consensus generation workflow [(PR #18)](https://github.com/phac-nml/vira/pull/18).
  - Includes two variant caller options in `Freebayes` (default) and `iVar`.
- Addition of an optional minor variant calling workflow for Nanopore sequencing data [(PR #14)](https://github.com/phac-nml/vira/pull/14).
- Addition of an optional Nextclade workflow including pre-sample dataset prediction [(PR #13)](https://github.com/phac-nml/vira/pull/13), [(PR #19)](https://github.com/phac-nml/vira/pull/19).
- Addition of virus specific workflow support [(PR #13)](https://github.com/phac-nml/vira/pull/13).
  - Currently, only includes Pangolin for SARS-CoV-2
  - More specific workflows to be added later on request or need

### `Removed`

- Deprecation of Medaka and Nanopolish as variant callers for Nanopore sequencing data [(PR #20)](https://github.com/phac-nml/vira/pull/20).
- Removal of MultiQC reporting [(PR #21)](https://github.com/phac-nml/vira/pull/21).

### `Changed`

- Restructuring of the Nanopore consensus generation workflow with modifications to:
  - Model handling [(PR #10)](https://github.com/phac-nml/vira/pull/10)
  - Primer scheme handling [(PR #12)](https://github.com/phac-nml/vira/pull/12)
  - Parameter adjustments and access [(PR #16)](https://github.com/phac-nml/vira/pull/16)
  - Variant calling [(PR #20)](https://github.com/phac-nml/vira/pull/20).
- Final reporting changes to use custom RMarkdown for HTML report generation both for the full run and individual samples [(PR #21)](https://github.com/phac-nml/vira/pull/21).
- Stability changes for optional snpEFF workflow [(PR #9)](https://github.com/phac-nml/vira/pull/9)
- Various tool version bumps and default parameter adjustments

## [1.2.0-dev] - Unreleased

Large update get ready to go into IRIDA-Next surveillance platform. Mostly focusing on best practices with not too many logic changes overall. `Clair3` has been made the default and recommended variant caller with most of the changes focusing on it. Primer schemes were also changed to just require a primer bed file and a reference file to make them easier to run

Parameters have been added and adjusted so that is something to be aware of. This is a dev release as we move to release 2.0.0 with all the changes coming later.

### `Added`

- Clair3 specific variant calling parameters [PR 6](https://github.com/phac-nml/vira/pull/6)
  - `--min_qual_clair3`
  - `--min_frameshift_qual`
  - `--min_allele_freq`
- Generic variant calling parameters added [PR 6](https://github.com/phac-nml/vira/pull/6)
  - `--min_depth`
- Primer bed parameter added to run primer schemes [PR 6](https://github.com/phac-nml/vira/pull/6)
  - `--primer_bed`
- Basic nf-tests added [PR 6](https://github.com/phac-nml/vira/pull/6)
- `nf-iridanext` plugin and config added [PR 6](https://github.com/phac-nml/vira/pull/6)

### `Removed`

- Specifics relating to amplicon primer-scheme repos and formatting to just require a bed and reference file [PR 6](https://github.com/phac-nml/vira/pull/6)
  - This includes the following parameters:
    - `--scheme`
    - `--scheme_version`
    - `--scheme_repo`
    - `--local_scheme`
  - Along with the workflows and processes associated with downloading and checking:
    - `DOWNLOAD_SCHEME`
    - `SIMPLE_SCHEME_VALIDATE`
- Removed the `CAT_FASTQ` module and process when creating the sample channel with the input list [PR 6](https://github.com/phac-nml/vira/pull/6)
  - Change made just as how it is being done needs to be reevaluated
- Resource `check_max` function removed from configs [PR 6](https://github.com/phac-nml/vira/pull/6)
  - Using the nextflow process resource limits instead
- `lib` folder and older nf-core groovy scripts and java jar deps [PR 6](https://github.com/phac-nml/vira/pull/6)
- `defaults` from conda env definition yaml channels [PR 6](https://github.com/phac-nml/vira/pull/6)

### `Changed`

- Minimum nextflow version bumped to `24.10.0` [PR 6](https://github.com/phac-nml/vira/pull/6)
- `nf-validation` replaces `nf-schema` [PR 6](https://github.com/phac-nml/vira/pull/6)
- The `lib/` folder has been replaced by `nf-validation` along with the nf-core utils subworkflows along with the local initialization subworkflow [PR 6](https://github.com/phac-nml/vira/pull/6)
- `--variant_caller` defaults to 'clair3' and isn't required to be set [PR 6](https://github.com/phac-nml/vira/pull/6)
- `--clair3_model` defaults to 'r1041_e82_400bps_sup_v420' now [PR 6](https://github.com/phac-nml/vira/pull/6)
- `--neg_ctrl_substrings` defaults to 'neg,ntc,blank,water' now (added in ',water') [PR 6](https://github.com/phac-nml/vira/pull/6)

### `ToDo`

- Fix SnpEff workflow
- Reevaluate more of the best practices for modules, parameters, workflows, and the modules.config file

## v1.1.0 - Unreleased

### `Added`

- Input schema JSON and validation
- FORMAT_INPUT workflow
  - Handles the input data now
- `nf-schema@2.0.0` plugin

### `Changed`

- `--input SAMPLESHEET_CSV` header
  - Went from `reads` with path to barcode directories to `fastq_1` with path to fastq files
- Fixed bug so that SNPEff will now work with given gff files
  - Issue was typo related in the build module
- Fixed bug with `calc_bam_variation` caused by genome case
- Log and error statements
- Fixed the cache directory statements

## [1.0.0] - 2024-03-22

Initial release of `phac-nml/vira`, created from combining the [nf-core](https://nf-co.re/) template with the artic steps.

### `Added`

- All initial pipeline features and logic
- All initial docs and images

[2.0.1]: https://github.com/phac-nml/vira/releases/tag/2.0.1
[2.0.0]: https://github.com/phac-nml/vira/releases/tag/2.0.0
[1.2.0-dev]: https://github.com/phac-nml/vira/commit/c23323caa4e6b91ced016217e89a399d94c245ec
[1.0.0]: https://github.com/phac-nml/vira/releases/tag/1.0.0
