#!/usr/bin/env perl

#use warnings;
#use strict;
$/ = "\/\/\n";
open (UNIPROT, "pre_zfin.dat") || die "Cannot open pre_zfin.dat : $!\n";

my @uniproRecords = <UNIPROT>;
my $ctRecords = 0;
# parsing the UniProt file

print "accession,entry_type,database,primary_id,secondary_id\n";

foreach my $record (@uniproRecords) {
    $ctRecords++;
    my @lines = split(/\n/, $record);
    my $prm_ac;
    foreach my $line (@lines) {

        if ($line =~ m/^AC\s+(.*)/) {
            $prm_ac = $1;
            # chop $prm_ac;
            my @prm_acc_list = split(/;/, $prm_ac);
            $prm_ac = $prm_acc_list[0];
            # chop $prm_ac;
        }

        ## DR   ZFIN; ZDB-GENE-131122-26; ikbip.
        ## could be multiple ZFIN ID
        if ($line =~ m/DR\s+ZFIN;\s+(ZDB-GENE\S+); (.*)\./) {
            $zfinidFromInput = $1;
            $zfinid = $zfinidFromInput;
            my $geneName = $2;
            print "$prm_ac,TrEMBL,ZFIN,$zfinid,$geneName\n";
        }

        ## DR   InterPro; IPR024152; Inh_kappa-B_kinase-int.
        ## could be multiple InterPro
        if ($line =~ m/DR   RefSeq; (.*); (.*)\./) {
            my $refseq1 = $1;
            my $refseq2 = $2;
            print "$prm_ac,TrEMBL,RefSeq,$refseq1,$refseq2\n";
        }

    }
}



close UNIPROT;


undef @uniproRecords;


