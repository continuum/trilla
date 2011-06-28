class ApiKeysController < ApplicationController
  include AuthenticationHelper
    
   def create
     current_user.enable_api!

     respond_to do |format|
       format.html { redirect_to "/perfil"}
     end
   end

   def destroy
     current_user.disable_api!

     respond_to do |format|
       format.html { redirect_to "/perfil" }
     end
   end
   
end
