//
//  LeaguesPresenter.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import Foundation
import Combine

class LeaguesPresenter: LeaguesPresenterProtocol {

    weak var view: LeaguesViewProtocol?

    var selectedSport: Sport?

    private var allLeagues: [League] = []
    private var leagues: [League] = []
    var isLoading: Bool = true
    
    private var searchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(view: LeaguesViewProtocol) {
        self.view = view
        setupSearchDebounce()
    }

    func viewDidLoad() {
        guard let sport = selectedSport?.sportName else { return }
        self.isLoading = true
        fetchLeagues(sport: sport)
        self.view?.showLeagues([])

    }
    func updateSearchQuery(_ query: String) {
            searchSubject.send(query)
        }
    private func setupSearchDebounce() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.leagues = self.allLeagues
                } else {
                    self.leagues = self.allLeagues.filter {
                        $0.leagueName?.lowercased().contains(query.lowercased()) ?? false
                    }
                }
                self.view?.showLeagues(self.leagues)
            }
            .store(in: &cancellables)
    }
    
    func fetchLeagues(sport : String , ){
        NetworkManager.shared.fetchLeagues(for: sport) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let leagues):
                    let sorted = leagues.sorted {
                        let firstHasImage = !($0.leagueLogo ?? "").isEmpty && URL(string: $0.leagueLogo!)?.pathExtension != ""
                        let secondHasImage = !($1.leagueLogo ?? "").isEmpty && URL(string: $1.leagueLogo!)?.pathExtension != ""
                        return firstHasImage && !secondHasImage
                    }
                    self?.allLeagues = sorted
                    self?.leagues = sorted
                    self?.view?.showLeagues(sorted)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }

    }
    func didSelectLeague(at index: Int) {
        if ReachabilityManager.shared.isConnectedToInternet {
            let selected = leagues[index]

            view?.navigateToLeagueDetails(
                with: selected,
                sport: selectedSport ?? Sport(sportName: "football", sportThumb: "")
            )
        }else{
            view?.showNoInternetAlert()
        }
    }
}
