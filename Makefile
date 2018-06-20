ASM	= rasm
IDSK	= iDSK

NAME	= test


CRT0 = asm/crt0.s
ADDR_CODE_MAIN = 0x170
ADDR_CODE_MAIN_LOAD = 0x170
ADDR_DATA_MAIN = 0


SRC_ASM_TEST = \
	./asm/main.asm

SRC_ASM = $(SRC_ASM_MAIN)

RM	= rm
DEFINES +=

all:
	$(ASM) $(SRC_ASM_TEST) -o $(NAME) -s -os test.map
	$(IDSK) $(basename $(NAME)).dsk -n
	$(IDSK) $(basename $(NAME)).dsk -f -i $(NAME).bin -t 1 -c $(ADDR_CODE_MAIN_LOAD) -e $(ADDR_CODE_MAIN_LOAD)
	cap32 $(basename $(NAME)).dsk -a  "run \"test\""


clean:

fclean: clean
	@$(RM) $(NAME)
	*.dsk

re: fclean all

.PHONY: all clean fclean re
