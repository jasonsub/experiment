This repository basically concludes my PhD research. Major tools & experiment
benchmarks are listed as tarballs in PhDConclude/. Dissertation can be found
in dissertation/submission/ as a PDF file.

First contribution is the sequential arithmetic verification tool as my DATE'15
paper described. At that time the experiment was done on Singular platform.
"code.tar" provides 3 typical Singular scripts for running experiments.
If you are seeking more details please look into sequential/RH_related and 
sequential/SMPO_tool. Since they are somewhat inefficient, I did not make 
a full tarball for the integrated tool. Actually I used C++ engine to get
better results, which appears in my disertation and will appear in a 
journal paper (hopefully when you read this, it has been published :) ).
Please download "Seq_verify_tool.tar.gz" for C++ engine based tool.

Second contribution is the unsat core extraction tool as my CP'16 paper presented.
"CNFbenchmarks.zip" provide a set of CNF benchmarks and a GBcore automated tool
for running it. Be careful, in the first try please attach -ns option,
because the syzygy identifying is costly on original benchmarks. To try out the
syzygy feature, you need to manually optimize the benchmark according to
first-step optimization output. If the benchmarks are not coming from CNF 
files, then you need to do it fully manually. Download "nonCNFbenchmarks.tar.gz"
to try out. Details refer to unsat/FINAL

Last contribution is the reachability analysis tool for general FSMs. Download
"HLDVT_upload.tar.gz" and try out manually. Note it actually provided you an
automated gadget in "push_button" folder, to transform BLIF benchmarks to
ALG files our engine can read. Above packages are also available on my webpage:
http://ece.utah.edu/~xiaojuns
as long as the University of Utah CADE lab does not delete my account.

Besides these main contributions, I also wrote down some other interesting
scripts and C++ codes, e.g. various parsers, solving a system of Galois field
polynomial equations using CUDD packages, etc. They are mostly trivial so I
would list them in the conclusion. For CUDD packages utilization, consulting
my colleague Utkarsh Gupta will be a better idea.

I will start my industry career at Cadence, and I am pretty sure that it won't
end at that company. Algorithm for circuits is just a start, there are much more
applications such like smart home, autonomous driving which are related to 
verification but using more attractive algorithms. We will see what I can do then.

Jan 05, 2017
Xiaojun Sun @ North Salt Lake
