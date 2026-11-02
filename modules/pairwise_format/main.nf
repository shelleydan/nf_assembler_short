#!/usr/bin/bash nextflow

process FastANIFormat {

    publishDir 'results/FastANI', mode: 'copy'

    input:
    path fastani_tsv

    output:
    path 'identity_matrix.tsv'

    script:
    """
    awk -F '\\t' '
    {
        gsub(".*/","",\$1)
        gsub(".*/","",\$2)
        gsub(".fasta","",\$1)
        gsub(".fasta","",\$2)

        ani[\$1,\$2] = \$3
        query[\$1]
        ref[\$2]
    }
    END {
        nref = asorti(ref, refs)

        printf "\\t"
        for (j=1; j<=nref; j++)
            printf "%s\\t", refs[j]
        printf "\\n"

        nquery = asorti(query, queries)

        for (i=1; i<=nquery; i++) {
            q = queries[i]

            printf "%s\\t", q

            for (j=1; j<=nref; j++) {
                r = refs[j]

                if ((q SUBSEP r) in ani)
                    printf "%.2f\\t", ani[q,r]
                else
                    printf "NA\\t"
            }
            printf "\\n"
        }
    }
    ' ${fastani_tsv} > identity_matrix.tsv
    """
}
