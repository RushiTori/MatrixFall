# Makefile by RushiTori - January 16th 2024
# ====== Everything Command Calls related ======

MAKEFLAGS += --no-print-directory
RM += -rf

# ========= Everything project related =========

PROJ    := MatrixFall
TARGET  := $(PROJ)
DTARGET := $(PROJ)_debug
COMP    := g++

ifdef OS
	TARGET  := $(TARGET).exe
	DTARGET := $(DTARGET).exe
endif

# ========== Everything files related ==========

INC_DIR   := include
SRC_DIR   := src
OBJ_DIR   := objs

HDS_FILES := $(wildcard $(INC_DIR)/*.hpp) $(wildcard $(INC_DIR)/**/*.hpp)
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/**/*.cpp)
OBJ_FILES := $(SRC_FILES:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
DEP_FILES := $(SRC_FILES:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.d)

# ========== Everything flags related ==========

INC_PATHS := $(addprefix -I , $(sort $(dir $(HDS_FILES))))
LIB_PATHS := 
LIB_FLAGS := -lsfml-graphics -lsfml-window -lsfml-system
STD_FLAGS := -std=c++20 -Wall -Wextra -Werror

ifdef OS
	INC_PATHS += -I C:/CustomLibs/include
	LIB_PATHS += -L C:/CustomLibs/lib
endif

EXE_FLAGS := $(INC_PATHS) $(LIB_PATHS) $(LIB_FLAGS) $(STD_FLAGS) -O3
D_FLAGS   := $(INC_PATHS) $(LIB_PATHS) $(LIB_FLAGS) $(STD_FLAGS) -g 
O_FLAGS   := $(INC_PATHS) $(STD_FLAGS) -O3

# =========== Every usable functions ===========

# Basic Build

build: $(TARGET)

$(TARGET): $(OBJ_FILES)
	@echo Linking $@
	@$(COMP) $^ -o $@ $(EXE_FLAGS)

start:
	@./$(TARGET)

# Debug Build

debug: $(DTARGET)

$(DTARGET) : $(OBJ_FILES)
	@echo Compiling $@
	@$(COMP) $^ -o $@ $(D_FLAGS)

startDebug:
	@gdb ./$(DTARGET)

# Obj files compiling

-include $(DEP_FILES)
objects: $(OBJ_FILES)
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo Compiling $< into $@
	@mkdir -p $(dir $@)
	@$(COMP) -c $< -o $@ $(O_FLAGS) -MMD

# File Cleaners

cleanAll:
	@$(MAKE) clean
	$(RM) $(TARGET)
	$(RM) $(DTARGET)

clean: 
	$(RM) $(OBJ_DIR)

# Makefile Debugging/Usefull Functions

restart: 
	@$(MAKE) --silent build
	@$(MAKE) --silent start

rebuild:
	@$(MAKE) --silent clean
	@$(MAKE) --silent build

redebug:
	@$(MAKE) --silent debug
	@$(MAKE) --silent startDebug

# Makefile Debugging/Usefull Functions
showOS: 
ifdef OS
	@echo Windows
else ifeq ($(shell uname), Linux)
	@echo Linux
else
	@echo ERROR
endif

showFiles:
	@echo Header files
	@echo $(HDS_FILES)
	@echo 
	@echo Source files
	@echo $(SRC_FILES)
	@echo 
	@echo Object files
	@echo $(OBJ_FILES)
	@echo 
	@echo Dep files
	@echo $(DEP_FILES)
	@echo 
