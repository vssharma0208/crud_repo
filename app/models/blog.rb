class Blog < ActiveRecord::Base
	default_scope -> {where('is_active = true')}

	validates :name, :presence => true
	validates :content, :presence => true

	def mark_delete
		self.update_column(:is_active, false)
	end
end
