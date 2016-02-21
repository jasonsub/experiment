# this is based on ETE2 package, visualizing a tree written in newick format (".nh" file)
# sudo apt-get install python-qt4 python-mysqldb setuptools (may exist typo..care)
# sudo easy_install -U ete2

from ete2 import Tree

t = Tree("2cores.dat.nh", format = 0)

t.render("mytree2.png", w=183, units="mm")
