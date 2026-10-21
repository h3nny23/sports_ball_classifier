SHELL := cmd.exe
.ONESHELL:
.PHONY: get-grayscale-data get-rgb-data clean-data

DATA_DIR := data
TRAIN_DIR := $(DATA_DIR)\train
TEST_DIR := $(DATA_DIR)\test

RGB_TRAIN_DIR := $(DATA_DIR)\rgb-train
RGB_TEST_DIR := $(DATA_DIR)\rgb-test

TMP_DIR := $(DATA_DIR)\.simpsons-tmp
REPO := https://github.com/alvarobartt/simpsons-mnist.git

# Grayscale
get-grayscale-data: $(TRAIN_DIR) $(TEST_DIR) clean-data

$(TMP_DIR):
	@if exist "$(TMP_DIR)" rmdir /S /Q "$(TMP_DIR)"
	git clone --filter=blob:none --no-checkout $(REPO) $(TMP_DIR)

$(TRAIN_DIR): $(TMP_DIR)
	cd $(TMP_DIR) && git sparse-checkout init --cone && git sparse-checkout set dataset/grayscale/train && git checkout
	@if not exist "$(TRAIN_DIR)" mkdir "$(TRAIN_DIR)"
	robocopy "$(TMP_DIR)\dataset\grayscale\train" "$(TRAIN_DIR)" /E /NFL /NDL /NJH /NJS || if %ERRORLEVEL% LEQ 7 exit 0

$(TEST_DIR): $(TMP_DIR)
	cd $(TMP_DIR) && git sparse-checkout set dataset/grayscale/test && git checkout
	@if not exist "$(TEST_DIR)" mkdir "$(TEST_DIR)"
	robocopy "$(TMP_DIR)\dataset\grayscale\test" "$(TEST_DIR)" /E /NFL /NDL /NJH /NJS || if %ERRORLEVEL% LEQ 7 exit 0

# RGB
get-rgb-data: $(RGB_TRAIN_DIR) $(RGB_TEST_DIR) clean-data

$(RGB_TRAIN_DIR): $(TMP_DIR)
	cd $(TMP_DIR) && git sparse-checkout init --cone && git sparse-checkout set dataset/rgb/train && git checkout
	@if not exist "$(RGB_TRAIN_DIR)" mkdir "$(RGB_TRAIN_DIR)"
	robocopy "$(TMP_DIR)\dataset\rgb\train" "$(RGB_TRAIN_DIR)" /E /NFL /NDL /NJH /NJS || if %ERRORLEVEL% LEQ 7 exit 0

$(RGB_TEST_DIR): $(TMP_DIR)
	cd $(TMP_DIR) && git sparse-checkout set dataset/rgb/test && git checkout
	@if not exist "$(RGB_TEST_DIR)" mkdir "$(RGB_TEST_DIR)"
	robocopy "$(TMP_DIR)\dataset\rgb\test" "$(RGB_TEST_DIR)" /E /NFL /NDL /NJH /NJS || if %ERRORLEVEL% LEQ 7 exit 0

clean-data:
	@if exist "$(TMP_DIR)" rmdir /S /Q "$(TMP_DIR)"