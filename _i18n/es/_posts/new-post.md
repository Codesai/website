# Introduction.

In previous posts<a href="#nota1"><sup>[1]</sup></a> we talked about the importance of distinguishing an object’s peers from its internals in order to write maintainable unit tests ([in this post]((https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class))). We also explained how the **peer-stereotypes** helped us detect an object’s peers ([in this other post](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries)). 

This post presents three effective techniques to discover an object’s peers beyond its **peer-stereotypes**.

Beware, when we use the term **object** we are using the meaning used in [Growing Object-Oriented Software, Guided by Tests (GOOS)](http://www.growing-object-oriented-software.com/) book: objects that “have an identity, might change state over time, and model computational processes”. They are not **values**,  and they can contain **internals** (see [our post about values, peers and internals](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class)).
# Other peer detection techniques.

The [GOOS](http://www.growing-object-oriented-software.com/) book, in a section titled *Where Do Objects Come From?*<a href="#nota2"><sup>[2]</sup></a>, describes three techniques for discovering object types that can, in turn, help us identify an object’s peers:
1. **Breaking Out**.
2. **Budding Off**.
3. **Bundling Up**.

These techniques identify recurring scenarios that indicate when introducing a new object improves the design. 

To identify peers using **Breaking Out** and **Bundling Up**, we rely on “listening to our tests” (using testability feedback to guide our design) . In contrast, to identify them with **Budding Off**, we rely on our domain knowledge and experience, and on our ability to recognize cohesion problems as we write a new failing test to drive new behaviour.

Once we’ve confirmed the need for a new peer, we introduce it by refactoring when applying **Breaking Out** and **Bundling Up**. When applying **Budding Off**
we instead introduce it while writing a new failing test.

<figure>
<img src="/assets/bablablabla.png"
alt="How we detect the need and the mechanism used to apply each of the techniques."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>How we detect the need and the mechanism used to apply each of the techniques<a href="#nota3"><sup>[3]</sup></a>.</strong></figcaption>
</figure>

In this post we focus on the **Breaking Out** technique. We will cover the other two in upcoming posts.
# **Breaking Out**.

The **Breaking Out** technique consists in “splitting a large object into a group of collaborating objects”<a href="#nota4"><sup>[4]</sup></a>.

When starting a new area of code, we might temporarily suspend our design judgment and just test-drive the code through the public interface of an object without attempting to impose much structure in order to give us time to learn more about the problem and any external APIs we’re developing against.

We might only extract into peers those behaviours that we can clearly identify as any of the peer stereotypes, **dependencies**, **notifications** and **adjustments**. Sometimes, we might even extract into peers only the collaborators required to be able to write unit tests, the **dependencies** which would result in test boundaries similar to the ones that the classic style of TDD produces.

## Signals that a **breaking out** is necessary.

After a short while, the object we are test-driving will become too complex to understand because of its poor cohesion[nota shorter than we think, señalar lo que dice Adam Tornhill y los artículos que cita] . We’ll likely observe code smells like *Divergent Change*, *Large Class*, *Data Clump*, *Primitive Obsession*, or *Feature Envy*. 

This lack of cohesion will also manifest in the tests as testability problems (test smells). We’ll likely observe tests that become too large to test the object's behavior easily, or test failures that become difficult to interpret. Their scope is too large.

## Applying the **breaking out**.

So we refactor by extracting functionality into smaller collaborating objects (collaborators) and values to make the large object follow the Single Responsibility Principle. This refactoring is what the GOOS book calls **Breaking Out**.
[Hablar de que no deberíamos tardar mucho en hacer esta limpieza porque blabla. Quizás citar alguno de los artículos sobre god objects & brain objects]. [Sacar de aquí motivos para no dejar ir este refactoring demasiado. Del GOOS:]“We have two concerns about deferring cleanup. The first is how long we should wait before doing something. Under time pressure, it’s tempting to leave the unstructured code as is and move on to the next thing (“after all, it works and it’s just one class...”). We’ve seen too much code where the intention wasn’t clear and the cost of cleanup kicked in when the team could least afford it. The second concern is that occasionally it’s better to treat this code as a spike—once we know what to do, just roll it back and reimplement cleanly. Code isn’t sacred just because it exists, and the second time won’t take as long.”
Notice that none of the new values and objects we have extracted by refactoring to improve the original object’s cohesion are its peers. First, values are not objects by definition, and, second, the collaborators we have extracted are internals not peers, because they are only “seen” by the object from which we extracted them, but nothing else.

## What about the tests?

Ok, now that we have removed the cohesion problems in the production code, what should we do with the testability problems we mentioned above? 

The original tests are still testing at the same time, both the behaviour of the original object and the behaviour of its collaborating objects and values. All the tests trigger the composed behaviour through the same entry point: the interface of the original object. This means that the tests are coarse-grained and unfocused. 

The extracted internal objects and values provide alternative interfaces that allow unit-testing their behaviours independently, so we don’t have to test all of them at the same time from the same entry point. So the question is: should we refactor the original coarse-grained, unfocused tests to split them into more fine-grained, focused tests using the new interfaces?

The answer is it depends. GOOS authors say that “we can [...] unit-test [the smaller collaborating objects] independently”, but they don’t say that we must do it right away. We may defer unit-testing them independently to a future moment if that it’s advantageous to us, or even not unit-test some of them if doing that doesn't cause testability problems that are too painful.

Before making a decision, let’s first examine the testability problems we may find in the tests, and how they relate to some of the desirable test properties described by Kent Beck in [test desiderata](https://testdesiderata.com/). 

We will specifically examine the following properties: [readability](https://www.youtube.com/watch?v=bDaFPACTjj8), [writability](https://www.youtube.com/watch?v=CAttTEUE9HM), [specificity](https://www.youtube.com/watch?v=8lTfrCtPPNE), [composability](https://www.youtube.com/watch?v=Wf3WXYaMt8E) and [structure-insensitiveness](https://www.youtube.com/watch?v=bvRRbWbQwDU).

### Bad things about coarse-grained, unfocused tests.

The coarse-grainedness and lack of focus of the original tests in itself can make them *harder to understand* which causes **poor readability**.

In addition, the inputs and outputs we use in some of those tests might be very different from the ones used by an internal behaviour we’re trying to validate. This happens because the more distance from the entry point to the interface of the internal behaviour, the more likely it’s that both input and output have been transformed by an intermediate behaviour. This difference in the inputs and outputs at both interfaces might make the test *harder to understand* which means an **even poorer readability**, and *costlier to write* (they take more effort) which introduces **writability problems** .


Another test smell we usually find in this kind of tests are *test failures that become difficult to interpret*. This means they also have **poor specificity**.

To finish, test-driving many behaviours at the same time might, in some cases, make it very difficult to break the composed behaviour into smaller increments of behaviour. [Behavioral composition](https://tidyfirst.substack.com/p/tdds-missing-skill-behavioral-composition) is important to keep a short feedback loop while doing TDD, and poor composability can impair our ability to test-drive behaviour. The original coarse-grained tests may also have **poor composability**.

### A good thing about coarse-grained, unfocused tests.

Not all it’s bad about the original tests because not knowing anything about the internal details of the original object, gives them a **high structure-insensitiveness** which is advantageous to reduce refactoring costs.

### Refactoring coarse-grained tests now or later?

After examining the test properties that are related with the possible code smells of the original coarse-grained tests we have more information to decide whether we should refactor the tests right away or defer it for a more advantageous time.

Another important thing to have in mind before deciding is how we got to this situation. Let’s recap quickly:  
1. We were starting a new area of code, and test-drove the code through the public interface of an object without attempting to impose much structure, so that we had more time to learn before committing to any design decision. 

2. After observing code smells and test smells we decided to break up the original object into smaller components. After that refactoring, the cohesion of the original object improved, and the composite object (original object + extracted internals and values) should have a clearer separation of concerns.


Now let’s examine the pros, cons and trade-offs of refactoring the tests now or later.

#### Context and trade-offs.

Let’s think first about what it would mean to start unit-testing the internal objects and values independently now, so that we can start easing the testability problems of the coarse-grained tests.

In a context in which we still don’t have enough knowledge about the problem to delimit the object’s boundaries well, it might be dangerous to prematurely coupling our tests to the interfaces of the internals and values we have just extracted, because that would reduce the structure-insensitiveness of the tests. The lower the structure-insensitiveness, the more expensive refactoring would be, if we later realize that any of the abstractions we introduced are not sound.[nota: An extreme case of poor structure-insensitiveness happens when we fall in the dangerous class-as-unit trap. Never go there!]

Since it’s likely that we have to do a lot of refactoring, as we learn more about the domain, it’s preferable to keep a high structure-insensitiveness to avoid increasing the cost of refactoring. So, in the context described above, deferring unit-testing the internal objects and values independently, and keep living with the coarse-grained tests for a while might be worth it.

We would be making a trade-off between structure-insensitiveness, and other desirable test properties like specificity, composability, readability and writability. We would be choosing to keep a high structure-insensitiveness, at the price of getting worse in those other desirable test properties. 

Having tests with low specificity, composability, readability and writability will soon slow us down and produce maintainability problems, but for a while, keeping a higher structure-insensitiveness might pay off because it allows us to more cheaply refactor to better abstractions and interfaces once we learn more. 

This trade-off pays off well until it doesn’t 🙂. This happens when the cost of poor specificity, readability, composability and/or writability start hurting us more than the benefit of low cost refactoring due to keeping a high structure-insensitiveness.

The tipping point where this trade-off stops paying off may happen due to different reasons, for instance:

a. We have learned enough about the problem, so that the code is more stable and has some degree of structure. Interfaces and abstractions are more stable and their refactoring becomes less likely. In this situation, the benefits of keeping high structure-insensitiveness start weighing less than the pains of having coarse-grained, unfocused tests.

b. The behaviour of an internal has evolved so complex that it exacerbates the specificity, composability, readability and/or writability problems, so much that those problems weigh more than the high structure-insensitiveness benefit of cheaper refactoring.

We might somehow palliate the pain of having tests with poor readability and writability by using explanatory helper methods and test patterns such as, [test data builder](http://www.natpryce.com/articles/000714.html), [object mother](https://martinfowler.com/bliki/ObjectMother.html), etc. Keep in mind, these techniques are just alleviating the symptoms, but they don’t fix the root of the problem:  having tests with too large a scope that test too many behaviours. In any case, they can be good enough to suffer less while keeping a higher structure-insensitiveness is advantageous for us.

However, if poor specificity starts being especially painful, we may need to start unit-testing independently some internal or value.

Poor composability may even make deferring unit-testing a given internal object independently impossible. In order to test-drive a complex behaviour keeping a short cycle, we need to break it into smaller increments of behaviour. Low composability might make it very difficult to apply [behavioral composition](https://tidyfirst.substack.com/p/tdds-missing-skill-behavioral-composition), so that we aren’t able to test-drive complex behaviours. In those cases, we would have no other choice but start test-driving independently some internal or value in order to reduce the size of the increments of behaviour we are tackling. Another option is promoting an internal to peer so that we can use test doubles for its role in the tests of the object that uses it.

To finish, keep in mind the context in which this strategy makes sense: when we don’t have enough knowledge to design well the scope of the object, so that we prefer to give ourselves more time to learn before committing to any design decision. 

In situations in which we have a more stable design, and/or enough knowledge of the domain, we have better odds that our design proves successful (designing is always a bet). Given what we knew, the decision we made would have been a good one, independently of its result [nota sobre Thinking in bets, poner link al video]. We’ll go deeper into this other context when we talk about the **Budding Off** technique.

[Hablar del riesgo de que los tests crezcan demasiado sin haber hecho el refactoring]
Keeping coarse-grained, unfocused tests when they give us no benefits can be dangerous blabla and blabla, so don’t wait too long. 

#### Refactoring the coarse-grained tests.

This is done in two steps:

1. Unit-testing “problematic” internals and values independently.
2. Refactoring the coarse-grained tests.

##### Unit-testing “problematic” internals and values independently.

We independently unit-test the internal or value that are any desirable test property in the object’s coarse-grained, unfocused tests. We don’t need to unit-test all of them, we can do it incrementally on a just-in-time basis.

These new fine-grained, focused tests are easier to understand and write. Besides, these new tests would directly improve the specificity because with them it is much easier to interpret test failures (including the original tests). 

Once we have these tests in place, we can refactor the original tests in order to simplify them and make them easier to maintain. There are several ways of simplifying the original tests, each with its own pros & cons:

a. Not promoting any internals to peers.
b. Promoting some internals to peers.

We’ll talk about them in detail later.

After this refactoring, the readability and writability of the original tests will have improved, because, by removing test cases and/or limiting their scope (it depends on which refactoring we apply), they will be more focused and easier to understand.

However, we pay a price for those gains: we lose structure-insensitiveness because the tests are now coupled to some of the internals and/or values of the object.

This trade-off is the reason why we should unit-test independently only the “problematic” internals or values. This is a sensible limitation because we unit-test them independently only for a reason: to ease specificity, readability and/or writability problems that are starting to become too painful for us. 

Remember that their behaviour is already tested. If we unit-tested independently any internal or value that is not problematic, we’d be trading structure-insensitiveness for nothing. This mistake would create unnecessary coupling between our tests and the structure of our code, and we’d be much worse off. 

##### Refactoring the coarse-grained tests.

Let’s look now at how to refactor the original tests. There are two ways of doing it:

a. Not promoting any “problematic” internals to peers.
b. Promoting some “problematic” internals to peers.

###### Not promoting any “problematic” internals to peers.

If we don’t promote any “problematic” internals to peers, what we can do to simplify the original coarse-grained tests would be removing most of the test cases that are addressing behaviours that are being more easily tested through closer, more appropriate interfaces.

This would reduce the size of the original tests alleviating the pains caused by writability and readability problems. In a way the pain is still there, but we don’t feel it so much because there are less test cases through the interface of the composite object.

Notice that the fine-grained, focused tests are coupled to the interface of the internal, but the coarse-grained ones are not, and now they are less unfocused 🚀.

Regarding specificity, even though failures may still affect several tests because there’s still an overlap in testing, it’s easier to diagnose the origin of the failure. If both some coarse-grained tests and some more focused tests fail, the problem is likely located in an internal or a value. Whereas, if only the coarse-grained tests fail the problem is likely located in the composite object.

Composability can also be addressed this way. It’s what classical TDD would do. When we are not able to test-drive an object because we can’t find a way to decompose its behaviour in small increments, we go one level of abstraction down, test-drive an internal object with a smaller behaviour, and then use it to test-drive the original behaviour more easily. The only problem here might be the inside-out nature of this way of working which is less YAGNI friendly. We need to be careful to only test-drive the internal behaviour that we need to make test-driving the whole behavior possible, and no more.

If specificity and/or composability are very painful, we may be better off using the other option: promoting some “problematic” internals to peers, but if they aren’t and we are still worried about structure-insensitiveness this approach might be good enough.


###### Promoting some “problematic” internals to peers.

In this case, after independently unit-testing a “problematic” internal collaborator, we simulate its behaviour with test doubles in the composite object’s tests.


Notice that in order to simulate a “problematic” internal in the composite object’s tests using test doubles, we first need to extract an interface[nota: necesitamos una interface porque tenemos dos implementaciones, una en el contexto de los tests y otra en el contexto de producción, no debemos hacer dobles de pruebas de clases, incluso si la herramienta nos lo permite, link al post de Freeman], invert the dependency and inject the internal into the object. Then we test the collaborator through the new interface. In other words, what we are actually doing is “promoting” the “problematic” internal into a peer of the object. 

Although those newly extracted peers don’t correspond to any of the object peer stereotypes, we argue that they get into what Fowler calls “interesting objects”[nota in Classical and Mockist Testing section of Mocks Aren't Stubs https://martinfowler.com/articles/mocksArentStubs.html] because of their “rich” behavior.

The tests using test doubles serve both as a discovering tool and a documentation of the communication protocols between the object and its peers. For the GOOS authors the communication patterns between objects are more important than the class structure, (see section *Communication over Classification* in chapter 7: *Achieving Object-Oriented Design*).

Specificity is better in this case. Now a failure can affect only either the composite object’s tests or the peer’s tests, so it’s straightforward to know where the problem is.

Composability can be addressed simulating the behaviours of the peers (its role) with test doubles while developing the behaviour of the composite object. And then we can implement the behaviour required to fulfil the role (the contract) in the implementation of the role. This is more outside-in than the other way and more YAGNI friendly than the approach we described in the previous section.

Now both the collaborator’s tests and the composite object’s ones are coupled to the peer’s interface. This approach increases the coupling between the tests and the production code only by degree. With this we mean that the tests are coupled to the same interfaces as in the previous approach, but from more places than in the previous approach.
This higher degree of coupling might be attenuated using fakes or using hand-made spies and stubs, but they may introduce other maintainability problems on their own[nota material para un futuro post].





## Summary.

Blablablabla, mejor al final de todo, con la ayuda de la AI.

## Notes.

<a name="nota1"></a> [1] blabla previous posts:

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class)
- ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people)
- [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries)

<a name="nota2"></a> [2] We mention the name of the section, *Where Do Objects Come From?*, because we think that its name is important to create a context for these techniques. The section is in chapter 7, *Achieving Object-Oriented Design*.

<a name="nota3"></a> [3] This mind map comes from a talk which was part of the **Mentoring Program in Technical Practices** we taught last year in [AIDA](https://www.domingoalonsogroup.com/es/empresas/aida).
<a name="nota4"></a> [4] Explained in subsection *Breaking Out: Splitting a Large Object into a Group of Collaborating Objects* from section, *Where Do Objects Come From?* on page 60 of GOOS book.


