# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#              manage_users GET    /manage/users(.:format)                                                                  manage/users#index
#                           POST   /manage/users(.:format)                                                                  manage/users#create
#           new_manage_user GET    /manage/users/new(.:format)                                                              manage/users#new
#          edit_manage_user GET    /manage/users/:id/edit(.:format)                                                         manage/users#edit
#               manage_user GET    /manage/users/:id(.:format)                                                              manage/users#show
#                           PATCH  /manage/users/:id(.:format)                                                              manage/users#update
#                           PUT    /manage/users/:id(.:format)                                                              manage/users#update
#                           DELETE /manage/users/:id(.:format)                                                              manage/users#destroy
#            manage_profile GET    /manage/profile(.:format)                                                                manage/user_profiles#show
#       manage_profile_edit GET    /manage/profile/edit(.:format)                                                           manage/user_profiles#edit
#                           PATCH  /manage/profile(.:format)                                                                manage/user_profiles#update
#     manage_dashboard_root GET    /manage(.:format)                                                                        manage/dashboard#index
#                      root GET    /                                                                                        home#index
#          new_user_session GET    /users/sign_in(.:format)                                                                 users/sessions#new
#              user_session POST   /users/sign_in(.:format)                                                                 users/sessions#create
#      destroy_user_session DELETE /users/sign_out(.:format)                                                                users/sessions#destroy
#         new_user_password GET    /users/password/new(.:format)                                                            users/passwords#new
#        edit_user_password GET    /users/password/edit(.:format)                                                           users/passwords#edit
#             user_password PATCH  /users/password(.:format)                                                                users/passwords#update
#                           PUT    /users/password(.:format)                                                                users/passwords#update
#                           POST   /users/password(.:format)                                                                users/passwords#create
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  namespace :manage do
    resources 'users', except: [:edit, :update]
    get '/profile' ,to: 'user_profiles#show'
    get '/profile/edit' ,to: 'user_profiles#edit'
    patch '/profile' ,to: 'user_profiles#update'
    get '/', to: 'dashboard#index', as: 'dashboard_root'
  end
  root to: "home#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
end
