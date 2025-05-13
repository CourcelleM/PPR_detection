import glob
import re
import sys
from os.path import join

#########################################
## SCRIPT PARAMETERS - READ FROM CONFIG FILE

# Directory with input fastq files and reference genome
RESOURCES="resources/"
RESDIR = "results/"

# Reference genome file
refgenome="PPR-UAE-1986-KJ867545.fasta"
#########################################

BWA_INDEX = ['amb','ann','pac','bwt.2bit.64','0123']
samples, = glob_wildcards(RESOURCES+"{sample}"+"_R1_001.fastq.gz")

def message(txt):
        sys.stderr.write("+++++ " + txt + "\n")

def errormessage(txt):
        sys.stderr.write("ERROR " + txt + "\n")

# Rules not sent on jobs
localrules: All

# Rules
rule All:
        input:
                expand(f"{RESDIR}0_cleaning/{{smp}}_R1_ATROPOS.fastq.gz", smp=samples),
                expand(f"{RESDIR}0_cleaning/{{smp}}_R2_ATROPOS.fastq.gz", smp=samples),
                expand(f"{RESDIR}1_mapping/{{smp}}_mapping-to-ref.sam", smp=samples)

rule BWAindexRef:
        input:
                Ref=RESOURCES+refgenome
        output:
                expand(f'{RESOURCES}{refgenome}.{{suffix}}',suffix=BWA_INDEX)
        conda:
                "envs/BWA_env.yaml"
        shell:
                """
                bwa-mem2 index {input}
                """

rule Atropos:
        input:
                R1 = f"{RESOURCES}{{samples}}_R1_001.fastq.gz",
                R2 = f"{RESOURCES}{{samples}}_R2_001.fastq.gz"
        output:
                R1 = f"{RESDIR}0_cleaning/{{samples}}_R1_ATROPOS.fastq.gz",
                R2 = f"{RESDIR}0_cleaning/{{samples}}_R2_ATROPOS.fastq.gz"
        conda:
                "envs/atropos_env.yaml"
        shell:
                """
                (atropos trim --threads 2 --minimum-length 35  -q 20,20  -U 8  -O 10 -o {output.R1} -p {output.R2} -pe1 {input.R1} -pe2 {input.R2})
                """

rule BWA_alignment:
	input:
		R1 = rules.Atropos.output.R1, 
		R2 = rules.Atropos.output.R2,
		Ref = f"{RESOURCES}{refgenome}",
		Index = rules.BWAindexRef.output
	output:
		temp(f"{RESDIR}1_mapping/{{samples}}_mapping-to-ref.sam")
	conda:
		"envs/BWA_env.yaml"
	shell:
		"""
		bwa-mem2 mem -t 2 -L 8,8 -B 2 {input.Ref} {input.R1} {input.R2} > {output}
		"""














