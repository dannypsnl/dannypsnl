# macro as type: racketfest(2021/03)

Hi, I'm Lim Tsu-Thuan, if you don't understand Taiwanese, then you can call me Danny.

Today, I'm going to present "Macro as Type".

Macro as Type? What does that mean?

It means we let this code (slide)

Became, this (slide)

As you can see, the conversion is quite simple, the key idea is reusing the environment of macro to store information of types. That is why we have `define-for-syntax` to bind name with type and have `define` to bind name with value.

But how? First, we could take a look at simply typed (slide)

As you see, in simply typed, we check the expected type same as the type of expression, and return the conversion.

At here, `typeof` is a helper, let's take a look (slide)

`typeof` basically only care about literals, and `eval` the rest of possible syntax, the power of this would show in the next example, Function. (slide)

We let this code become (slide)

this

Now, we need to check the type of body, but how to get parameters? Since we use `eval`, the task has been easy, (slide) introduce `let` is enough. This is our inference for function body.

---

Above shows the ability to create a new thing, time to talk about interacting with the old thing.

Claim (slide) is such functionality. From what you see, the claim is just binding type-level, no more. Let's see its example (slide)

As you can see, here I claim add1 as number to number, then apply string to it would cause an error.

Next is generic, or type free-variable if you fimilar with type theory. (slide)

Here is the classic identity function, expansion as simple as a normal function, the only interesting part is the following check (slide)

As you see, we only need one more `let` to introduce free variables for unification. (slide)

The last thing is the arbitrary length parameter, it only stands for parameters, this is promised when constructing function type, and will automatically be extracted and fit the length of arguments before unification. (slide)

---

Now we had enough understanding about the syntax and convertion, we could have some core functions, **Unification** is the most important one.

Unification is a simple process, it repeatly ask: type A can be unified with type B?

In this type system, four conditions need to be considering in unification algorithm.

1. unify free-variable with Type or Type with free-variable

    in this situation, free-variable unbound can unify with any Type
    
    free-variable bound can unify with unbound free-variable, or bound free-variable that bound same thing, or the bound.
    
2. function type with function type

    function type first ensure another type is a function type, then unify with it, by checking every parameter types are same, then check return types are same.
    
3. higher type with higher type

    higher type is the type depends on type, for example, `(List ?A)` is a type if `?A` is a type, but `List` is not a type but a type constructor. Noticed that, function type also a kind of higher type. As function type, we check the names are same, then we check all element types are same.
    
4. Type with Type

    The last condition comparing Types with `equal?`, if they are not same, raise a syntax error.

(slide)

---

Time to talk about limitations (slide)

The first thing could be noticed, might be dependent type couldn't use such technology, at least, not directly use. The biggest problem was, dependent type would require type and value avaliable in the same level. For example, `define-for-syntax zero Nat` and `define-for-syntax zero 'zero`.

Another limitation was conflict, in our `typeof` helper, `eval` seems solved all problems.

However, not that easy, to check application in define, eval would raise apply on non-procedure exception. To solve this problem, we hijack application form, however, this would also hijack `let`. Therefore, we need to escape let form to help generic and parameter work correctly. By the way, we also escape lambda form, and provide type free variable for inferred type of the lambda form.

---

In the future, I would keep digging about 
1. how to reusing module?
2. can we support dependent type?
3. and can we solve conflict in a better way?

This is the end, you could get more information in the link, thanks for listen.
