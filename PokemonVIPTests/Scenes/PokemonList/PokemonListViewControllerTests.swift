//
//  PokemonVIPTests.swift
//  PokemonVIPTests
//
//  Created by Ihwan on 05/01/22.
//

import XCTest
@testable import PokemonVIP

class PokemonListViewControllerTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: PokemonListViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
      super.setUp()
      window = UIWindow()
      setupPokemonListViewController()
    }
    
    override func tearDown()
    {
      window = nil
      super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupPokemonListViewController()
    {
      let bundle = Bundle.main
      let storyboard = UIStoryboard(name: "Main", bundle: bundle)
      sut = storyboard.instantiateViewController(withIdentifier: "PokemonListViewController") as? PokemonListViewController
    }
    
    func loadView()
    {
      window.addSubview(sut.view)
      RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class PokemonListBusinessLogicSpy: PokemonListBusinessLogic
    {
      var pokemons: [Pokemon]?
      
      // MARK: Method call expectations
      
      var fetchPokemonsCalled = false
      
      // MARK: Spied methods
      
      func fetchPokemons(request: PokemonList.FetchPokemons.Request)
      {
        fetchPokemonsCalled = true
      }
    }
    
    class TableViewSpy: UITableView
    {
      // MARK: Method call expectations
      
      var reloadDataCalled = false
      
      // MARK: Spied methods
      
      override func reloadData()
      {
        reloadDataCalled = true
      }
    }
    
    // MARK: - Tests
    
    func testShouldFetchPokemonsWhenViewDidAppear()
    {
      // Given
      let pokemonListBusinessLogicSpy = PokemonListBusinessLogicSpy()
      sut.interactor = pokemonListBusinessLogicSpy
      loadView()
      
      // When
      sut.viewDidAppear(true)
      
      // Then
      XCTAssert(pokemonListBusinessLogicSpy.fetchPokemonsCalled, "Should fetch pokemons right after the view appears")
    }
    
    func testShouldDisplayFetchedPokemons()
    {
      // Given
      let tableViewSpy = TableViewSpy()
      sut.tableView = tableViewSpy
      
      // When
        let displayedPokemons = [PokemonList.FetchPokemons.ViewModel.DisplayedPokemon(name: "Agumon")]
      let viewModel = PokemonList.FetchPokemons.ViewModel(displayedPokemons: displayedPokemons)
      sut.displayFetchedPokemons(viewModel: viewModel)
      // Then
      XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched pokemons should reload the table view")
    }
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne()
    {
      // Given
      let tableView = sut.tableView
      
      // When
      let numberOfSections = sut.numberOfSections(in: tableView!)
      
      // Then
      XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfPokemonsToDisplay()
    {
      // Given
      let tableView = sut.tableView
      let testDisplayedPokemons = [PokemonList.FetchPokemons.ViewModel.DisplayedPokemon(name: "Pokemon")]
      sut.displayedPokemons = testDisplayedPokemons
      
      // When
      let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
      
      // Then
      XCTAssertEqual(numberOfRows, testDisplayedPokemons.count, "The number of table view rows should equal the number of pokemons to display")
    }
    
    func testShouldConfigureTableViewCellToDisplayPokemon()
    {
      // Given
      let tableView = sut.tableView
      let testDisplayedPokemons = [PokemonList.FetchPokemons.ViewModel.DisplayedPokemon(name: "Pokemon")]
      sut.displayedPokemons = testDisplayedPokemons
      
      // When
      let indexPath = IndexPath(row: 0, section: 0)
      let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
      
      // Then
      XCTAssertEqual(cell.textLabel?.text, "Pokemon")
      
    }

}
