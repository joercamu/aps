class ModificationAttachmentsController < ApplicationController
	before_action :set_modification_attachment, only: [:destroy]
	before_action :set_modification, only: [:create,:destroy]
	load_and_authorize_resource

	def new
		@modification_attachment = ModificationAttachment.new
	end
	def create
		# file send for user
		file_to_upload = params[:modification_attachment][:file]
		filename = file_to_upload.original_filename
		content_type = file_to_upload.content_type.split("/").first
		nid = Digest::MD5.hexdigest("#{filename.upcase}#{DateTime.now}")
		directory = "public/uploads/"
      	extension = filename.slice(filename.rindex("."), filename.length).downcase
      	if extension == ".pdf" or extension == ".doc" or extension == ".docx" or extension == ".jpg" or extension == ".png"
         	#Ruta del archivo.
			path = File.join(directory, "#{nid}#{extension}")
			#Crear en el archivo en el directorio. Guardamos el resultado en una variable, será true si el archivo se ha guardado correctamente.
			resultado = File.open(path, "wb") { |f| f.write(file_to_upload.read) }
			#Verifica si el archivo se subió correctamente.
			if resultado
				@modification_attachment = current_user.modification_attachments.new(name:filename,name_original:filename,nameid:"#{nid}#{extension}",ext:extension,content_type:content_type)
				@modification_attachment.modification = @modification
				if @modification_attachment.save
					redirect_to @modification_attachment.modification, notice:'El adjunto se ha cargado correctamente.'
				else
					redirect_to @modification_attachment.modification, notice:'Ocurrio un error mientras intentábamos guardar el archivo'
				end
			else
				redirect_to @modification, notice:'Ocurrio un error mientras intentábamos cargar el archivo'
			end
		else
			redirect_to @modification, notice:"No se aceptan archivos con la extension #{extension}"
      	end
	end
	def destroy
		if @modification_attachment.user == current_user
			@modification_attachment.destroy
			redirect_to @modification, notice:"Adjunto eliminado correctamente"
		else
			redirect_to @modification, notice:"Solo puede eliminar el archivo quien lo subio."
		end
	end

	private
	def set_modification_attachment
		@modification_attachment = ModificationAttachment.find(params[:id])
	end
	def set_modification
		@modification = Modification.find(params[:modification_id])
	end
	def modification_attachment_params
		params.require(:modification_attachment).permit(:name,:name_original,:nameid,:ext,:user_id)
	end
end
