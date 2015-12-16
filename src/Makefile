

# gathering solved tasks
solutions:=$(shell ls Task???/Makefile)

reports:=$(solutions:Makefile=report.txt)

all: summary.txt

.PRECIOUS: %.out %.res

.SECONDEXPANSION:

summary.txt: $(reports)
	perl count-points.pl $^ | tee $@

%/report.txt: $$(subst .in,.res,$$(wildcard %/*.in))
	echo CREATING REPORT FOR $@
	perl create-report.pl $^ > $@

%.res: %.out %.exp
	(diff $^ > $@ || exit 0)

%.out: $$(@D)/run %.in
	chmod u+x $<
	$< $*.arg < $(word 2,$^) > $@

clean:
	rm -f $(BINARIES)
	rm -f summary.txt
	find . -name '*.out' -exec rm '{}' ';'
	find . -name '*.res' -exec rm '{}' ';'
	find . -name 'report.txt' -exec rm '{}' ';'

-include Task*/Makefile
