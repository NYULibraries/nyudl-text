Gem functionality:
nyudl-<object type>
* initialize with directory path
* valid?
* recognized?
* errors
  :unrecognized_files
* struct [attributes: for type]
** intellectual entities
*** logical sections
**** logical section
***** slot
****** hash: key = role, value = fileid

* rename?
* rename_plan
* rename!
* check


* struct
** @struct is a Nokogiri object
** require 'active_support'
** Hash.from_xml(@nokogiri_object.to_xml).to_json
** returns a JSON representation of the text structure
*** basic structure:
**** root
***** intellectual 
