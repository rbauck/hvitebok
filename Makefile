# Makefile for hviteboka
#
# For � oppdatere hviteboka:
# �pne en UNIX-terminal
# Skriv "cd sti/til/denne/Makefile".
# Skriv "make" eller "make LaTeX=ltx" p� IfI
# "make logclean" for � slette logger

# F�lgende linje tildeler navnet p� hoved-LaTeX-fila (den som inneholder
# \documentclass, \begin{document} og \end{document}) til variabelen
# hovedfil.
hovedfil = hvitebok.tex

# F�lgende linje inneholder navnene p� alle filene til hviteboka,
# adskilt med mellomrom. Hovedfila er ogs� med fra forrige linje.
# Dersom det er mange filnavn, kan man fortsette p� neste linje ved
# � avslutte linja med en backslash (\).
filer := ${hovedfil} kildekode/formand.tex \
          kildekode/kjellermester.tex  kildekode/skjenkemester.tex \
          kildekode/sekretar.tex  kildekode/infosjef.tex \
          kildekode/fagsjef.tex  kildekode/arrsjef.tex \
          kildekode/internansvarlig.tex  kildekode/kafe.tex \
          kildekode/okonomiutvalget.tex  kildekode/donaldsjef.tex \
          kildekode/lover.tex  kildekode/generelt.tex \
          kildekode/arr/allefestersmor.tex kildekode/arr/karneval.tex\
	  changelog.tex kildekode/alkoholreklame.tex

basenavn := $(basename ${hovedfil})

# F�lgende linjer inneholder filer for � kompilere lovene
lov = lover
lover = ${lov}.tex kildekode/lover.tex

# Disse linjene forteller hvilke program vi skal bruke
# *.tex til *.dvi: (ltx funker best p� ifi)
LaTeX = latex
#LaTeX = ltx

# *.tex til *.pdf: (ltx2pdf funker best p� ifi)
ifeq (${LaTeX},ltx) 
PDFLaTeX = ltx2pdf
else
PDFLaTeX = pdflatex
endif

# *.dvi til *.ps: $@ blir byttet ut med regelnavnet
DVIPS = dvips -o $@

# Dette er den f�rste regelen. Man kan velge hvilken regel man skal 
# bruke ved � skrive make regelnavn. Den f�rste brukes dersom ingen
# er oppgitt. Regelen all bruker reglene pdf ps og dvi.
all: hb lover

hb: ${basenavn}.pdf ${basenavn}.ps ${basenavn}.dvi
lover: ${lov}.pdf ${lov}.ps ${lov}.dvi

# Dette er regelen pdf. Regelen pdf bruker regelen hvitebok.pdf
pdf: ${basenavn}.pdf ${lov}.pdf

# Dette er regelen ps. Regelen ps bruker regelen hvitebok.ps
ps: ${basenavn}.ps ${lov}.ps

# Dette er regelen dvi. Regelen dvi bruker regelen hvitebok.dvi
dvi: ${basenavn}.dvi ${lov}.dvi

# Denne regelen bruker Subversion til � generere en changelog
changelog:
	svn log | iconv -t utf-8 > changelog

# Denne texer den forrige filen
changelog.tex: changelog
	perl mkchlog.pl changelog > changelog.tex

# Renser opp
logclean:
	-rm ${basenavn}.{log,aux}

clean: logclean
	-rm ${basenavn}.{ps,pdf,dvi}

# Regler er vanligvis p� formen
# filnavn: filer som brukes for � generere filnavn
# Det vil si at regelen bare brukes dersom fila filnavn er eldre enn
# en eller fler av filene som er listet opp. Regelen .PHONY er en
# spesialregel som sier at reglene nevnt ikke er filnavn
.PHONY: all pdf ps dvi logclean clean hb lover

# Dette er regelen hvitebok.pdf, som kj�rer programmet for PDFLaTeX
${basenavn}.pdf: ${filer}
	${PDFLaTeX} ${hovedfil}

# Dette er regelen hvitebok.ps, som genererer en PS-fil fra dvifila.
# $^ erstattes av .dvi-filnavnet
%.ps: %.dvi
	${DVIPS} $^

# Dette er regelen hvitebok.dvi
${basenavn}.dvi: ${filer}
	${LaTeX} ${hovedfil}

${lov}.dvi: ${lover}
	${LaTeX} ${lov}

${lov}.pdf: ${lover}
	${PDFLaTeX} ${lov}


