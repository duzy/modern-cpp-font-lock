#pragma once

#define EXPAND_ME __FILE__ " : " __LINE__

constexpr auto pi = 314LLu;
thread_local decltype(pi) rage = 0b10;

[[deprecated("abc")]] char16_t *f() noexcept { return nullptr; }

template <typename T> struct Foo {
  static_assert(std::is_floating_point<T>::value,
                "Foo<T>: T must be floating point");
};

struct A final : Foo {
  A() = default;
  [[noreturn]] virtual void foo() override;
};

// TODO: ....
// FIXME: ...
template <typename T> concept bool EqualityComparable = requires(T a, T b) {
  { a == b } -> bool;
};

namespace
{
  enum E0 {
    A,
    B,
    C,
  };
  
  enum class E1 {
    A,
    B,
    C,
    D,
  };
  
  enum class E1 : int {
    A,
    B,
    C,
    D,
  };
}

void fun() 
{
  std::generate_n(std::begin(i), 4, [] {
    static int g;
    {
      (void) false;
    }
    return g++;
  });

  if (!blah(1, 2, 3, 4)) {
    return;
  }
  
  call(object{
    { "...1" },
    { "...2" },
    { "...3" },
  });
}
