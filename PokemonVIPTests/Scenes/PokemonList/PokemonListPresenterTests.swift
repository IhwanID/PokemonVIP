//
//  PokemonListPresenterTests.swift
//  PokemonVIPTests
//
//  Created by Ihwan on 06/01/22.
//

import XCTest
@testable import PokemonVIP

class PokemonListPresenterTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: PokemonListPresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
      super.setUp()
      setupPokemonListPresenter()
    }
    
    override func tearDown()
    {
      super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupPokemonListPresenter()
    {
      sut = PokemonListPresenter()
    }
    
    // MARK: - Test doubles
    
    class PokemonListDisplayLogicSpy: PokemonListDisplayLogic
    {
      // MARK: Method call expectations
      
      var displayFetchedPokemonsCalled = false
      
      // MARK: Argument expectations
      
      var viewModel: PokemonList.FetchPokemons.ViewModel!
      
      // MARK: Spied methods
      
      func displayFetchedPokemons(viewModel: PokemonList.FetchPokemons.ViewModel)
      {
        displayFetchedPokemonsCalled = true
        self.viewModel = viewModel
      }
    }
    
    // MARK: - Tests
    
    func testPresentFetchedPokemonsShouldFormatFetchedPokemonsForDisplay()
    {
      // Given
      let pokemonListDisplayLogicSpy = PokemonListDisplayLogicSpy()
      sut.viewController = pokemonListDisplayLogicSpy
      
      // When
      let pokemons = [Pokemon(name: "Agumon")]
      
      let response = PokemonList.FetchPokemons.Response(pokemons: pokemons)
      sut.presentFetchedPokemons(response: response)
      
      // Then
      let displayedOrders = pokemonListDisplayLogicSpy.viewModel.displayedPokemons
      for displayedOrder in displayedOrders {
        XCTAssertEqual(displayedOrder.name, "Agumon", "Presenting fetched orders should properly format name")
      
      }
    }
    
    func testPresentFetchedPokemonsShouldAskViewControllerToDisplayFetchedPokemons()
    {
      // Given
      let pokemonListDisplayLogicSpy = PokemonListDisplayLogicSpy()
      sut.viewController = pokemonListDisplayLogicSpy
      
      // When
      let pokemons = [Pokemon(name: "Agumon")]
      let response = PokemonList.FetchPokemons.Response(pokemons: pokemons)
      sut.presentFetchedPokemons(response: response)
      
      // Then
      XCTAssert(pokemonListDisplayLogicSpy.displayFetchedPokemonsCalled, "Presenting fetched orders should ask view controller to display them")
    }

}
