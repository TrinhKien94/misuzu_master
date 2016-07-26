Jpt::Application.routes.draw do
  resources :kairans do
    collection {post :confirm, :kaitou_create}
    collection {get :shokairan}
    member {get :kaitou, :send_kairan_view}
  end
  resources :kairanyokenmsts
  resources :tsushinseigyous
  resources :dengonyoukens
  resources :dengonkaitous
  resources :dengons

  root to: 'main#index'
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  resources :bashokubunmsts

  resources :bunruis

  resources :shoninshamsts

  resources :ekis do
    collection {post :import}
  end

  resources :kikanmsts do
    collection {post :import}
  end

  resources :kintais do
    collection {get :search}
  end

  resources :events, only: [:index, :new, :create, :edit, :update] do
		collection {post :ajax, :custom, :create_basho, :create_kaisha, :time_line_view}
    collection {get :time_line_view}
	end

  resources :bashomasters do
    collection {post :ajax, :import}
  end

  resources :jobmasters do
    collection {post :ajax, :import}
  end

	match 'main', to: 'main#index', via: [:get]

  resources :users do
    collection {get :change_pass}
    collection {post :change_pass}
  end

  resources :yakushokumasters, param: :id do
  end

  resources :jpt_holiday_msts do
  end

  resources :shainmasters do
  end

  resources :keihiheads do
    collection {post :ajax, :shonin_search}
    collection {get :shonin_search}
  end

  resources :shozokumasters do
    collection {post :import}
  end

  resources :joutaimasters do
    collection {post :import}
  end

  resources :kaishamasters, param: :id do
    collection { post :import}
  end

  resources :shozais do
    collection { post :import}
  end

  constraints(:id => /\w+(,\w+)*/) do
    resources :kouteimasters do
      collection {post :ajax}
    end
  end
  # map.connect ':controller/:action/:id', :id => /\w+(,\w+)*/
end
