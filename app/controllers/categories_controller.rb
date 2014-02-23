class CategoriesController < AuthenticatedController

	def index
		@categories = Category.all
	end

end