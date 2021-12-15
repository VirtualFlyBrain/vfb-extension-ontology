## Customize Makefile settings for vfbext
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# use STAR module and exclude individuals for OBI to reduce size
imports/obi_import.owl: mirror/obi.owl imports/obi_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/obi_terms_combined.txt --force true --copy-ontology-annotations true --individuals exclude --method STAR \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && \
		mv $@.tmp.owl $@ && rm imports/obi_terms_combined.txt; fi


$(ONT).owl: $(ONT)-full.owl
	grep -v owl:versionIRI $< > $@.tmp.owl
	$(ROBOT) annotate -i $@.tmp.owl --ontology-iri http://virtualflybrain.org/data/VFB/OWL/vfbext.owl \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@
