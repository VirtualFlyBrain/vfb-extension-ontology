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

# making obo versions of imports (from Makefile on FBbt repo, not sure why this is not in Makefile here)
IMPORT_OBO_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).obo)
IMPORT_FILES = $(IMPORT_OWL_FILES) $(IMPORT_OBO_FILES)

imports/%_import.obo: imports/%_import.owl
	if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f obo -o $@.tmp.obo && mv $@.tmp.obo $@; fi
