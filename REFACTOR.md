## Refactoring considerations
1) text-gen-mets Filename class methods
2) for each filename type, what messages do objects need to respond to?

From `text-gen-mets`:
#name_without_role
#role
#path
#extension
#rootname
#name
#rootname_minus_role
#rootname_minus_index_and_role

From `nyudl-text``
#prefix
#fname
#newname
#role


nyudl-text filename.rb:
classes for: 
EOC
README
front matter
body
back matter
target
mods
marcxml
metsrights


Other features:
shift(n) where n can be positive or negative
change type, e.g., dmaker --> target





Book-level functions:
shift-down

