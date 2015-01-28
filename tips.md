Searches and substitutes
========================

- Replacement has matched expression in it. (Helpful for OR).  Replace any of
  three different words with that word surrounded by underscore

    ```
    :s/wordA\|wordB\|wordC/_\0_/gc
    ```

- Match a word that is not preceded by a certain word.  Match all bar that are
  not "foo bar".

    ```
    /\(foo \)\@<!bar
    ```

- Match a word that is not followed by a certain word.  Match all foo that are
  not foobar

    ```
    /foo\(bar\)\@!
    ```
