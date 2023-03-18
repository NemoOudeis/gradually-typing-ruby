---
marp: true
paginate: ture
theme: gaia
author: Nemo
title: Gradually Typing Ruby
style: |
  .two-columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
# for columns see this discussion
# https://github.com/marp-team/marp/discussions/192 
---


# **Gradually Typing Ruby**

<!--
Hi, I'm Nemo.
Today I'll talk about Gradually Typing Ruby code.
You might ask: Hey, doesn't have Ruby types already? And aren't they all ducks?
What I'll talk about is static typing, as in "compile" time check-able.
Gradually as in: you have some ruby code and you incrementally add type definitions to it.
-->

---

# Why would I want static types in ruby?

<!--
I'll tell you why I want types and how you can do this. I won't talk about general advantages and drawbacks of static typying or compare static to dynamic typing.
There's plenty of material out there and it always depends on your situation - team, project, preference.
-->

---

```shell
cloc --include-lang=ruby .
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Ruby                         1,954         26,371         15,083        119,623
-------------------------------------------------------------------------------
```

<!--

My situtation:  I'm handling 100k+ LOC of legacy code. 
By "legacy" I mean: "not written by me within the last 3 months".
But It also means
* grown over 10 years
* written by many authors, with differing opinions on design, most of which are no longer with us
* varying levels of tests and obseravbility
-->

---

```ruby
def load_and_build_account_signal(account_id)
  # What is account_id?
  


end
```

<!-- 
In code context, when I often come across a method like this
I ask myself - what is account_id?
Maybe an integer (DB id)
Maybe a string (uuid etc)
And I'll assume `nil` is a possibility
-->

---

```ruby
def load_and_build_account_signal(account_id)
  # What is account_id?
  if account_id.is_a?(Hash)
    account_id = account_id.dig('account', 'id')
  end
  # so it's nil, string, int or hash... maybe?
end
```

<!-- 
Then I read on and see that...

...dynamic typing FTW!

Unit tests can help here a bit - but they can also be deceiving. Sometimes I find unit tests that only pass integers, but in actual code we support uuids and integer ids.
Other times unit tests pass, but only because some dependency is stubbed out and in a production environment that value fails. We don't have integrated test for all our code (which is a topic for another talk or 10)

So: sometimes I don't know what assumptions I can make within a method/function. I have try to keep all possible states in my mind while changing that code.
-->

---

```ruby
poller.call(opts)
 ↘︎ 
   poll_and_work(opts)
    ↘︎ 
      work_on_task(opts)
       ↘︎ 
         activity_handler.work(opts)
          ↘︎ 
            importer.import_statement(opts)
```

What is in `opts`?

<!--
Or I have to jump up and down the call stack to understand what states I can rule out - to reduce the mental load.

Note that none of this is a stab at developers who came before me. I am certain that everybody had the best intentions writing the code and that they made the best choices they could at the time. Code just has a tendency to sparwl and overgrow and entangle until it becomes unmanagable. Especially at the low level.
-->

---

<!-- I found existing code to be  -->

🤔 hard to understand
\+
🦶🔫 easy to make mistakes
\+
⚙️ "it's working in prouction"
\=
😰 scary to make a change

<!-- 
I know that other people in the company feel similarly.
-->

---

# 🎯 Make Code Easy To Change

<!-- 
I asked myself and the team how we can make easier to understand and change safely.
The idea of static typing has come up before, in  
in 2018 they experimented with Sorbet. At the time they were uncertain about the runtime overhead and they shelved the effort.

With the knowledege that typing is welcome idea and that performance is a critical consideration, I set read up on RBS. In our quarterly hack days I prototyped it out and it turned out to be a good fit for us.
-->

---

![bg 80%](./img/check-yourself-1.webp)

---


[Sorbet](https://sorbet.org/) | [RBS](https://github.com/ruby/rbs)   | [Steep](https://github.com/soutaro/steep)
------ | ------------- | ----
![width:100px](https://github.com/sorbet/sorbet/raw/master/docs/logo/sorbet-logo-purple-sparkles.svg) | ∅ | ∅
By Stripe | By Ruby 3 | By [soutaro](https://github.com/soutaro)
Good docs | Minimal docs | Minimal docs
3.4k ⭐️ | 1.6k ⭐️ | 1.1k ⭐️

---

# Writing Type definitions

<div class="two-columns">
<div>

```ruby
class EmailContact
  attr_accessor :name, :email, :message

  def intialize(name:, email:, message:)
    name = name
    email = email
    message = message
  end

  def deliver
    # imagine the amazing implementation
  end
end
```

</div>
<div>

```shell
$ bundle exec steep check
# Type checking files:

.............................................F
lib/gradually_typing_ruby.rb:1:6: [warning] 
Cannot find the declaration of class: `EmailContact`
│ Diagnostic ID: Ruby::UnknownConstant
│
└ class EmailContact
        ~~~~~~~~~~~~

Detected 1 problem from 1 file
```

</div>



---
# Writing Type definitions

<div class="two-columns">
<div>

```ruby
class EmailContact
  attr_accessor :name, :email, :message

  def intialize(name:, email:, message:)
    name = name
    email = email
    message = message
  end

  def deliver
    # imagine
  end
end
```

</div>
<div>

```ruby
class EmailContact
  attr_accessor name: String
  attr_accessor email: String
  attr_accessor message: String

  def initialize: (String, String, String) -> void
  def deliver: () -> void
end
```

</div>
</div>



---

![bg](./img/check-yourself-2.webp)

---