class BlogsController < ApplicationController
	before_action :verify_user
	skip_before_action :verify_authenticity_token
	before_action :find_blog, only: [:patch_data, :destroy_data]


	def index
	end

	def verify_user
		@response_hash = {}
		if params[:token].blank? or params[:token] != "MY_TOKEN"
			@response_hash[:message] = "Access Denied, Please contact the admin"
			render :json => @response_hash.to_json
			return
		end
	end

	def fill_data
		if Blog.create(blog_params)
			@response_hash[:status] = "OK"
			@response_hash[:message] = "Successfully Created A Blog"
		else
			@response_hash[:status] = "400"
			@response_hash[:message] = "Something Went wrong"
		end
		render :json => @response_hash.to_json
	end

	def get_data
		page = params[:page]
		page = 1 if page.blank?
		if page.class != Fixnum
			@response_hash[:status] = "400"
			@response_hash[:message] = "Page parameter should be an integer"
			render :json => @response_hash
			return
		end
		offset = (10 * (page - 1)) rescue 0
		blogs = Blog.limit(10).offset(offset).map{|blog| {"name" => blog.name, "content" => blog.content}}
		if blogs.present?
			@response_hash[:status] = "OK"
			@response_hash[:message] = "success"
			@response_hash[:data] = blogs
		else
			@response_hash[:status] = "400"
			@response_hash[:message] = "Something Went wrong"
		end
		render :json => @response_hash.to_json
		return
	end

	def find_blog
		puts "#{params[:blog][:id].blank?}==========#{params[:blog][:id].class}"
		if params[:blog][:id].blank?
			@response_hash[:status] = "400"
			@response_hash[:message] = "Please pass blog id"
			render :json => @response_hash.to_json
			return
		end
		blog_id = params[:blog][:id].to_i
		@blog = Blog.find(blog_id)
		if @blog.blank?
			@response_hash[:status] = "400"
			@response_hash[:message] = "Couldn't find blog with such id"
			render :json => @response_hash.to_json
			return
		end
	end

	def patch_data
		if @blog.update_attributes(blog_params)
			@response_hash[:status] = "OK"
			@response_hash[:message] = "Successfully Updated"
			render :json => @response_hash.to_json
			return
		else
			@response_hash[:status] = "400"
			@response_hash[:message] = "Something Went Wrong"
			render :json => @response_hash.to_json
			return
		end
	end

	def destroy_data
		if @blog.mark_delete
			@response_hash[:status] = "OK"
			@response_hash[:message] = "Successfully Deleted"
			render :json => @response_hash.to_json
			return
		else
			@response_hash[:status] = "400"
			@response_hash[:message] = "Something Went Wrong"
			render :json => @response_hash.to_json
			return
		end
	end

	private
	def blog_params
		params.require(:blog).permit(:name, :content)
	end
end
