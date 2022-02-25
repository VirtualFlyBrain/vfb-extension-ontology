## Customize Makefile settings for vfbext
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


# Add VFB iri
$(ONT).owl: $(ONT)-full.owl
	grep -v owl:versionIRI $< > $@.tmp.owl
	$(ROBOT) annotate --input $@.tmp.owl --ontology-iri http://virtualflybrain.org/data/VFB/OWL/vfbext.owl \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

# smaller CARO import
$(IMPORTDIR)/caro_import.owl: $(MIRRORDIR)/caro.owl
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract --method MIREOT --force true --copy-ontology-annotations true \
		--lower-term "obo:CARO_0030002" \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi


# Include copying import files
.PHONY: prepare_release
prepare_release: $(ASSETS)
	rsync -R $(RELEASE_ASSETS) $(RELEASEDIR) &&\
	rsync -R $(IMPORT_FILES) $(RELEASEDIR) &&\
  rm -f $(CLEANFILES) &&\
	rm -f imports/*_terms_combined.txt &&\
  echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on your git hosting site such as GitHub or GitLab"
