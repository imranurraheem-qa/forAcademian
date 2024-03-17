Feature: Academian Assignment
  Assignment for Sr Test Engineer

	Background:
    * configure driver = { type: 'chrome', addOptions: ["--remote-allow-origins=*"] }
    
  Scenario: Automate the Add to cart functionality and verify the added products
    Given driver 'https://www.saucedemo.com/'
    * driver.maximize()
    And input('input#user-name', 'standard_user')
    * focus('#password')
    And input('#password', 'secret_sauce')
    When click("//input[@id='login-button']")
    * delay(2000)
    Then match driver.title == 'Swag Labs'
		And waitFor("//div[@class='inventory_list']/div[@class='inventory_item']//button[contains(@id, 'add-to-cart')]")
    #Add to the Cart all items that are shown on the page
    And def products = locateAll("//div[@class='inventory_list']/div[@class='inventory_item']//button[contains(@id, 'add-to-cart')]")
   	* print karate.sizeOf(products)
   	* def productsCount = karate.sizeOf(products)
   	And products.forEach(product => product.click())
 		#Verify the number of items that show up on the Cart Icon at the top right
 		And string productsCountStr = productsCount
 		And def cartBadge = text("//span[@class='shopping_cart_badge']")
    And match productsCountStr == cartBadge
    #Fetched titles for each products
   	And def allProducts = locateAll("//div[@class='inventory_list']//div[@class='inventory_item']//a[contains(@id, 'title_link')]")
    And def allProductTitles = []
    * print karate.sizeOf(allProducts)
    * eval karate.forEach(allProducts, function(product){ karate.appendTo(allProductTitles, product.script('_.innerText')) })
    * print 'Product Titles:', allProductTitles
    #Click on the cart icon to navigate to the Cart Page
    When click("//a[@class='shopping_cart_link']")
    * delay(2000)
    #Verify that all the products are reflected on the cart page
    Then def cartProducts = locateAll("//div[@class='cart_list']//div[@class='cart_item']")
    * print karate.sizeOf(cartProducts)
    * def cartProductsCount = karate.sizeOf(cartProducts)
    #1. Verifying the count of added products
    And match productsCount == cartProductsCount
    #2. Verifying the title of the products
    And def productTitleCart = locateAll("//div[@class='cart_item']//div[@class='inventory_item_name']")
    And def allProductTitlesCart = []
    * print karate.sizeOf(productTitleCart)
    * eval karate.forEach(productTitleCart, function(productTitle){ karate.appendTo(allProductTitlesCart, productTitle.script('_.innerText')) })
    * print 'Product Titles Cart:', allProductTitlesCart
    And match allProductTitlesCart contains allProductTitles