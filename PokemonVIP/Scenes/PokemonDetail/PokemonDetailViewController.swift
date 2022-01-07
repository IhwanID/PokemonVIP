//
//  PokemonDetailViewController.swift
//  PokemonVIP
//
//  Created by Ihwan on 07/01/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PokemonDetailDisplayLogic: AnyObject
{
  func displaySomething(viewModel: PokemonDetail.PokemonDetail.ViewModel)
}

class PokemonDetailViewController: UIViewController, PokemonDetailDisplayLogic
{
  var interactor: PokemonDetailBusinessLogic?
  var router: (NSObjectProtocol & PokemonDetailRoutingLogic & PokemonDetailDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = PokemonDetailInteractor()
    let presenter = PokemonDetailPresenter()
    let router = PokemonDetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
  }
  
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = PokemonDetail.PokemonDetail.Request()
    interactor?.getPokemon(request: request)
  }
  
  func displaySomething(viewModel: PokemonDetail.PokemonDetail.ViewModel)
  {
      nameLabel.text = viewModel.displayedPokemons.name
      pokemonImageView.load(url: URL(string: viewModel.displayedPokemons.images)!)
  }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
