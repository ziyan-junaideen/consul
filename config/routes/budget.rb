resources :budgets, only: [:show, :index] do
  resources :groups, controller: "budgets/groups", only: [:show]

  resources :investments, controller: "budgets/investments", only: [:index, :new, :create, :show, :destroy] do
    member do
      post :vote
      put :flag
      put :unflag
    end

    collection { get :suggest }
  end
  
  resources :ideas, controller: "budgets/ideas", only: [:index, :new, :create, :show, :destroy] do
    member     { post :vote }
    collection { get :suggest }
  end

  resource :ballot, only: :show, controller: "budgets/ballots" do
    resources :lines, controller: "budgets/ballot/lines", only: [:create, :destroy]
  end

  resource :results, only: :show, controller: "budgets/results"
end

scope '/participatory_budget' do
  resources :spending_proposals, only: [:index, :new, :create, :show, :destroy], path: 'investment_projects' do
    post :vote, on: :member
  end
end

get 'investments/:id/json_data', action: :json_data, controller: 'budgets/investments'
get 'ideas/:id/json_data', action: :json_data, controller: 'budgets/ideas'
