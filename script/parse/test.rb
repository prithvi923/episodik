require 'nokogiri'

f = File.open("test.xml")
@doc = Nokogiri::XML::Document.parse(f)

node = @doc.xpath('/root/group/name')




f.close



puts node
