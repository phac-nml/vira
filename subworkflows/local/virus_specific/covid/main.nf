/*
    Subworkflow to run covid specific tools
        1. Identifies covid lineages

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { PANGOLIN_UPDATEDATA  } from '../../../../modules/nf-core/pangolin/updatedata/main'
include { PANGOLIN_RUN         } from '../../../../modules/nf-core/pangolin/run/main'
include { STAGE_FILE_IRIDANEXT } from '../../../../modules/local/custom/utils.nf'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN SUBWORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
workflow WF_VIRUS_COVID {
    take:
    ch_consensus        // channel: [ val(meta), path(consensus) ]

    main:
    ch_versions = Channel.empty()

    //
    // Lineage analysis with Pangolin
    //
    ch_pangolin_report = Channel.empty()

    if (!params.skip_pangolin) {
        if (!params.pango_database) {
            PANGOLIN_UPDATEDATA('pangolin_db')
            pango_database = PANGOLIN_UPDATEDATA.out.db
            ch_versions   = ch_versions.mix(PANGOLIN_UPDATEDATA.out.versions.first())
        } else {
            pango_database = Channel.value(file(params.pango_database, type: 'dir'))
        }

        PANGOLIN_RUN (
            ch_consensus,
            pango_database
        )
        ch_versions = ch_versions.mix(PANGOLIN_RUN.out.versions.first())

        STAGE_FILE_IRIDANEXT(PANGOLIN_RUN.out.report
            .map{ _meta, csv -> csv }
            .collectFile(name: 'lineage_report.csv', keepHeader: true, skip: 1, cache: false)
        )
        ch_pangolin_report = STAGE_FILE_IRIDANEXT.out.collect()
    }

    emit:
    pangolin_report  = ch_pangolin_report            // channel: [ path(lineage_report.csv) ]
    versions         = ch_versions                   // channel: [ path(versions.yml) ]
}
