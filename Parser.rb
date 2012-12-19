require 'nokogiri'
require 'open-uri'

class Grabber
	def initialize(url,number)
		@url=url
		@number=number		
	end
	def search
		mas=Array.new
		mas.push @url
		def func(n,mas)
		if n>0 
			a=Array.new
			for i in 0..mas.size-1
				begin
					p = Nokogiri::HTML(open(mas[i]))
				rescue Errno::ENOENT
					mas.delete_at(i)
					next
				end	
				p.css('a').each do |link|
					if link['href']!=nil
						if link['href'][0]=='#'
							next
						elsif (link['href'][0]=='/')
							a.push mas[i]+link['href']
						else	
							a.push link['href']
						end	
					end	
				end	
				a.uniq!	
				a.unshift mas[i]
				mas[i]=a
				#puts mas[i]
				func(n-1,mas[i])
			end	
		end	
		end
			
		func(@number,mas)
		f = File.open('Result.txt', "w+")
		mas.each{|e| puts e}
		mas.each{|e| f.puts e}
		f.close
	end

end

g=Grabber.new("http://google.com",2)
g.search
