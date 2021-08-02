## Customize Makefile settings for vfbext
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# making obo versions of imports (from Makefile on FBbt repo, not sure why this is not in Makefile here)
IMPORT_OBO_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).obo)
IMPORT_FILES = $(IMPORT_OWL_FILES) $(IMPORT_OBO_FILES)

.PHONY: all_imports
all_imports: $(IMPORT_FILES)

imports/%_import.obo: imports/%_import.owl
	if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f obo -o $@.tmp.obo && mv $@.tmp.obo $@; fi
