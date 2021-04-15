# Notes on Elixir

These are things that I found interesting while learning Elixir.

## Table of Contents

  - [Basics](#basics)
  - [Pattern Matching](#pattern-matching)
  - [Testing and Documentation](#testing-and-documentation)
  - [Data Structures](#data-structures)
  - [Phoenix](#phoenix)
## Basics

* `iex -S mix` opens the interactive shell to run elixir commands, compile etc.
* When inside the interactive shell, if we want to recompile the code (after we did some change) we can do `recompile` and it will recompile everything.
* [Elixir Documentation](https://hexdocs.pm/elixir/Kernel.html)
* You can add a questionmark in the end of a function name. It's not special character. It's a convention though that the function with a question mark will return true of false.
* When doing a comprehension (a for loop) the result of each iteration is being entered in an array and that array is returned (if it's the last thing on a function)
* To assign the result of the above comprehension to a variable all we need to do is add it before the loop like so:

  ```elixir
  value = for item <- items do
    item
  end
  ```
* You can run multiple comprehensions in one for loop.
  ```elixir
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  ```
* A Tuple is a combination of 2 elements surrounded with curly braces. E.g. `{[1], [2,3,4]}`
* You can add Erlang code in an Elixir file. Doing `:erlang.` will give us access to a lot of Erlang functions. For example `:erlang.term_to_binary(deck)`
* Putting an underscore alone, or an underscore before a variable name tells Elixir that we won't need that variable.
* When using the pipe operator `|>` the result of one function is being piped as the first entry to the next one
* Adding dependencies in `mix.exs` in the `defp deps do` section can be installed by running the command `mix deps.get`
* Using the `++` operator we can merge two lists. For example `[1, 2] ++ [3,4]` will give us `[1, 2, 3, 4]`
* Doing `alias ModuleName` is saying to elixir that "If you don't find the function in this module, then look into the ModuleName instead. Basically it's as if all the module functions exist in the module where you are calling alias from. If you try to call that function though from outside the module you will get a failure. They are private.
* Doing `import ModuleName` works very similarly with alias with the distinct difference that you can then call all the functions you imported from outside the module. They are not private.
* To create a default argument in a function we can use `\\`. For example:
  ```elixir
  def do_something(name \\ "George") do
    ....
  end
  ```
* To define a private function that can be called only from within the module I do `defp functionName do`

## Pattern matching

* Pattern matching is Elixirs replacement for variable assignment. The equivalent in Javascript would be variable destructuring.
* Doing `{ firstVar, secondVar } = { [1,2,3], [4,5,6] }` will give us `firstVar -> [1,2,3]` and `secondVar -> [4,5,6]`
* Instead of using if statements it's best to use `case` statements and pattern matching. E.g.
  
  ```elixir
  {status, binary} = File.read(filename)

    case status do
      :ok -> :erlang.binary_to_term(binary)
      :error -> "That file does not exist"
    end
  ```
* When doing pattern matching the right hand side and the left hand side must match. For example `["red", color] = ["red", "blue"]` will work and it will assign `color -> "blue"` because the first element matches. If we do though `["red", color] = ["green", "blue"]` this won't work and it will through an error. The reason being that `"red" != "green"`
* If while pattern matching you want the first X items of a list but not the rest then we can do `[a, b, c | _rest] = superList`.
* You can do pattern matching straight in the definition of a function like so `def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do`

## Testing and documentation

* Installing the dependency `{:ex_doc, "~> 0.12"}` helps us create nice documentation for our project. To do so, after installing it, we can run `mix docs`.
* Adding `@moduledocs """ ... """` in the beginning of the module allows us to add documentation for the entire module.
* Adding `@doc """ ... """` over a specific function enables us to add documentation for a that function.
* We can add examples in our documentation by identation the example with 3 tabs like so:
```elixir

  ## Examples

      iex> Cards.create_deck()
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
```
* The examples are also working as [Doctests too](https://elixir-lang.org/getting-started/mix-otp/docs-tests-and-with.html)

## Data structures

* To create a **Map** we can do `colors = %{primary: "Red", secondary: "Blue"}`. To access them we can either do `colors.primary` or via pattern matching `%{primary: first_colour} = colors`. That way `first_colour` will be `Red`.
* Data in Elixir are immutable so we can't update a map like so `colors.primary = "Green"`. One way to update it is to do `Map.put(colors, :primary, "Green")`. Note that this returns a new map, it doesn't mutate the original one. An alternative way to update the map is to do `%{ colors | primary: "Green" }`. Again this doesn't mutate the original object, it returns a new one. It works very similar with Javascript spread operator and adding after the spread the new variable you want to change.
* To create a **Keyword List** we can do `colors = [(:primary, "Red"), {:secondary, "Blue"}]` and the result we will get is going to be `[primary: "Red", secondary: "Blue"]`. To access one of those we can do `colors[:primary]` and we will get back `Red`.
* Alternatively we can avoid the curlies when defining a keyword list. We can just do `colors = [primary: "Red", secondary: "Blue"]` and it will work the same way.
* The big difference between a `Map vs a Keyword List` is the fact that on a map you can have a key only once, where in a keyword list we can have it as many times as we want.
* **Structs** are data structures similar to maps but with a couple of extra benefits. They can be assigned default values and they have a compile time checking of the properties.
* To create a data structure we do `%Identicon.Image{}`. This will create a new struct with the default values. If we want to update it we can do `Identicon.Image{ image | color: {r, g, b}}` (where image is the original struct we are modifying).

## Phoenix

* To create a new project you can do `mix phx.new projectName`. To use live add the `--live` flag in the end of the new command.
* If you are using VSCode you might want to configure Emmet to accept `HTML (Eex)` in the included languages. Just add `HTML (Eex) : html` in your configuration and you should be good.
* Running `iex -S mix phoenix.server` starts the phoenix server inside iex. That helps us with debugging.
* The Models in phoenix come in the form of database migration scripts and they live in the `priv/repo/migrations` folder.
* By running `mix ecto.gen.migration <NAME>` we are able to generate a new migration file. To do the migration we do `mix ecto.migrate`.
* If, while creating an app, you have a module that you want to include to all of your controllers, the best place to add it is in the `module_web.ex` file. In my project, where the name is `Discuss` this file is called `discuss_web.ex`. There in the controller definition you can add more modules. Same goes for views etc.
* To create a new context (the model) in phoenix you need to run the command `mix phx.gen.context Accounts User users name:string age:integer`. [Documentation here](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Context.html).
* To pass a custom variable to a template you need to pass it in the render function. For example: `render(conn, "index.html", changeset: changeset)`. Changeset is a custom variable.
* Running `mix phx.routes` will give you all the available routes
* [Phoenix Ecto cheatsheet](https://devhints.io/phoenix-ecto)
* If you are following REST conventions then instead of writing multiple handlers for each link like so:
```elixir
  get("/", TopicController, "index.html")
  get("/topics/new", TopicController, :new)
  post("/topics", TopicController, :create)
```
we can just do: `resources("/", TopicController)` and it will automatically generate all REST routes.
* Using `put_session(:user_id, user.id)` will drop a cookie in the current session with whatever we pass in the function. The cookie is encrypted