#!/bin/bash

# Define the list of links
links_list="<ul>
<li><a href=ReadComics.html>See Full Catalog</a></li>
<li><a href=Aje.html>Aje</a></li>
<li><a href=Amadioha.html>Amadioha</a></li>
<li><a href=Assegai.html>Assegai</a></li>
<li><a href=Avonome.html>Avonome</a></li>
<li><a href=Beatz.html>Beatz</a></li>
<li><a href=BlackMoon.html>BlackMoon</a></li>
<li><a href="Deadrepublic.html">Dead Republic</a></li>
<li><a href=CrDark.html>CR Dark</a></li>
<li><a href="Deadrepublic.html">Dead Republic</a></li>
<li><a href=ERU.html>ERU</a></li>
<li><a href=GalacticCore.html>Galactic Core</a></li>
<li><a href=GoForGold.html>Go For Gold</a></li>
<li><a href=GuardianPrimeGenesis.html>Guardian Prime Genesis</a></li>
<li><a href=HeroGen.html>Hero Gen</a></li>
<li><a href=HeroKekere.html>Hero Kekere</a></li>
<li><a href=Iretibidemi.html>Ireti Bidemi</a></li>
<li><a href=IretiMoremi.html>Ireti Moremi</a></li>
<li><a href=Itan.html>Itan</a></li>
<li><a href=MetaiyeKnights.html>Metaiye Knights</a></li>
<li><a href=Metalla.html>Metalla</a></li>
<li><a href=MightOfGuardianPrime.html>Might Of Guardian Prime</a></li>
<li><a href=Ndoli.html>Ndoli</a></li>
<li><a href=Presurrection.html>Presurrection</a></li>
<li><a href=ScionImmortal.html>ScionImmortal</a></li>
<li><a href=TrialsOftheSpear.html>Trials Of The Spear</a></li>
<li><a href=Tatashe.html>Tatashe</a></li>
<li><a href=Tearsheet.html>Tear sheet</a></li>
<li><a href=Uhuru.html>Uhuru legend of the windriders</a></li>
<li><a href=Vanguards.html>Vanguards</a></li>
<li><a href=Visionary.html>Visionary</a></li>
<li><a href=CharacterBible.html>Character Bible</a></li>
</ul>"

# Extract all the links ending with ".html" from the list
html_links=$(echo "$links_list" | grep -oE 'href="?([^"#]+\.html)"?' | sed -E 's/href="?([^"#]+\.html)"?/\1/g')

# Prepend "https://thecomicrepublic.com/site/" to each link and attach a number
complete_links=$(echo "$html_links" | awk '{print NR-1, "https://thecomicrepublic.com/site/"$0}')

# Print out the complete links with styling
echo -e "\n\033[1mComplete Links:\033[0m"
echo -e "\033[36m----------------------------------\033[0m"

echo "$complete_links" | while read -r number link; do
  echo -e "\033[32m$number)\033[0m $link"
done

echo -e "\033[36m----------------------------------\033[0m"

# Ask the user to choose a number
read -p $'\033[1mEnter the number corresponding to the link you want to download:\033[0m ' choice
echo

# Use curl to download the chosen link
chosen_link=$(echo "$complete_links" | awk -v choice="$choice" 'NR-1 == choice {print $2}')

# Use curl to access the chosen link and look for .pdf links
pdf_links=$(curl -s "$chosen_link" | grep -oE 'href="?([^"#]+\.pdf)"?' | sed -E 's/href="?([^"#]+\.pdf)"?/\1/g')

# Clean up the pdf links
cleaned_pdf_links=$(echo "$pdf_links" | sed 's/viewer\.html?file=//')

# Print out the .pdf links with numbering and styling
echo -e "\033[1mPDF Links:\033[0m"
echo -e "\033[36m----------------------------------\033[0m"

if [[ -n "$cleaned_pdf_links" ]]; then
  echo "$cleaned_pdf_links" | awk '{print NR-1, $0}' | while read -r number pdf_link; do
    # Add "https://thecomicrepublic.com/site/" to the front of the pdf link and append "?f#pdfjs.action=download"
    pdf_link="https://thecomicrepublic.com/site/$pdf_link?f#pdfjs.action=download"

    echo -e "\033[32m$number)\033[0m $pdf_link"
  done
else
  echo -e "\033[31mNo PDF links found.\033[0m"
fi

echo -e "\033[36m----------------------------------\033[0m"

