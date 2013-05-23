class HandlebarTemplate		
	
	$handlebars = Handlebars::Context.new

	def self.add_template( m )

		meth = File.basename( m, ".html.erb" )

		$handlebars.register_partial( meth, File.read("source/templates/#{m}") )

		define_method meth do |opts|
			opts[:class] = meth
			$handlebars.compile("{{>#{meth}}}").call( opts )
		end

	end

end

class String
	def safe
		proc { Handlebars::SafeString.new( self ) } 
	end
end