## Customize Makefile settings for vfbext
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# remove _terms_combined files
CLEANFILES := $(CLEANFILES) imports/*_terms_combined.txt


# Add VFB iri
$(ONT).owl: $(ONT)-full.owl
	grep -v owl:versionIRI $< > $@.tmp.owl
	$(ROBOT) annotate --input $@.tmp.owl --ontology-iri http://virtualflybrain.org/data/VFB/OWL/vfbext.owl \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@
