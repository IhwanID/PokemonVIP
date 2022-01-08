//
//  PokemonListInteractorTests.swift
//  PokemonVIPTests
//
//  Created by Ihwan on 06/01/22.
//

import XCTest
@testable import PokemonVIP

class PokemonListInteractorTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: PokemonListInteractor!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupPokemonListInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupPokemonListInteractor()
  {
    sut = PokemonListInteractor()
  }
  
  // MARK: - Test doubles
  
  class PokemonListPresentationLogicSpy: PokemonListPresentationLogic
  {
    // MARK: Method call expectations
    
    var presentFetchedPokemonsCalled = false
    
    // MARK: Spied methods
    
    func presentFetchedPokemons(response: PokemonList.FetchPokemons.Response)
    {
      presentFetchedPokemonsCalled = true
    }
  }
  
  class PokemonListWorkerSpy: PokemonListWorker
  {
    // MARK: Method call expectations
    
    var fetchPokemonsCalled = false
    
    // MARK: Spied methods
    
    override func fetchPokemons(completionHandler: @escaping ([Pokemon]) -> Void)
    {
      fetchPokemonsCalled = true
      completionHandler([])
    }
  }
  
  // MARK: - Tests
  
  func testFetchPokemonsShouldAskPokemonListWorkerToFetchPokemonsAndPresenterToFormatResult()
  {
    // Given
    let pokemonListPresentationLogicSpy = PokemonListPresentationLogicSpy()
    sut.presenter = pokemonListPresentationLogicSpy
      let pokemonListWorkerSpy = PokemonListWorkerSpy(pokemonService: PokemonServiceAPI())
    sut.worker = pokemonListWorkerSpy
    
    // When
    let request = PokemonList.FetchPokemons.Request()
    sut.fetchPokemons(request: request)
    
    // Then
    XCTAssert(pokemonListWorkerSpy.fetchPokemonsCalled, "fetchPokemons() should ask PokemonListWorker to fetch pokemons")
    XCTAssert(pokemonListPresentationLogicSpy.presentFetchedPokemonsCalled, "fetchPokemons() should ask presenter to format pokemon result")
  }
}
