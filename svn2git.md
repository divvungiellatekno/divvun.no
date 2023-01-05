# Fra svn til git

## Forberedelse

Sjekk ut langtech_to [clean_lang_history](https://github.com/giellalt/giellalt/clean_lang_history.git)

```bash
git svn clone https://gtsvn.uit.no/langtech/trunk langtech_as_git
git clone --mirror --no-local langtech_as_git/ lt
cd lt
git filter-repo --prune-empty always --strip-blobs-bigger-than 10M
```

## Utforske

```bash
cd ../langtech_as_git/
gitk&
```

### 18054276199d58d028f4f58602f3fbbe420c8185

```bash
❯ git log -n 1
commit 18054276199d58d028f4f58602f3fbbe420c8185 (HEAD)
Author: thomas <thomas@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Mon Jan 12 09:14:31 2015 +0000

    corrections

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@105350 c7155fb1-f0a7-4240-a2fc-2600b6f42f90

❯ find xtdoc/sd -type l |fgrep -v '.xml' |xargs ls -l
lrwxrwxrwx 1 boerre boerre 28 ođđj  4 11:02 xtdoc/sd/plugins -> ../../tools/forrest-plugins/
lrwxrwxrwx 1 boerre boerre 36 ođđj  4 11:02 xtdoc/sd/src/documentation/content/xdocs/future/proofing -> ../../../../../../../plan/proof/doc/
```

#### /sd

* xdocs/future/proofing -> /plan/proof/doc/

```bash
commit 62ed10b11f0d7adca4b56bd50b7bc989bce79c4e
Author: boerre <boerre@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Fri Jan 21 16:36:25 2005 +0000

    Initial revision


    git-svn-id: https://gtsvn.uit.no/langtech/trunk@2370 c7155fb1-f0a7-4240-a2fc-2600b6f42f90
```

#### sd2

```git
commit 09e8fdf6b97a9af171bb863be44df41f673f630b
Author: boerre <boerre@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Thu Dec 4 14:13:16 2014 +0000

    Copy of sd, for experimenting

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@103900 c7155fb1-f0a7-4240-a2fc-2600b6f42f90
```

### main

#### historien til divvun

flyttet fra sd

```git
commit 6e24018405e6ba7dd5f266b12646e55725807799
Author: boerre <boerre@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Tue Apr 28 15:46:49 2015 +0000

    Move the divvun site to a better name

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@112692 c7155fb1-f0a7-4240-a2fc-2600b6f42f90
```

#### nåværende softlinker til kataloger

```bash
find xtdoc/divvun -type l |fgrep -v '.xml'
xtdoc/divvun/plugins
```

### 6e24018405e6ba7dd5f266b12646e55725807799

```bash
❯ find xtdoc/divvun -type l |fgrep -v '.xml'
xtdoc/divvun/plugins
xtdoc/divvun/src/documentation/content/xdocs/future/proofing
```

### 3ef13c4b78f54ad3015cdf2eee894eed9cf476e6

```bash
❯ git log -n 1
commit 3ef13c4b78f54ad3015cdf2eee894eed9cf476e6 (HEAD)
Author: jaska <jaska@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Thu Jan 26 19:23:42 2012 +0000

    These are Komi-language abbreviations.

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@53313 c7155fb1-f0a7-4240-a2fc-2600b6f42f90

❯ find xtdoc/sd -type l |fgrep -v '.xml' |xargs ls -l
lrwxrwxrwx 1 boerre boerre 28 ođđj  4 11:02 xtdoc/sd/plugins -> ../../tools/forrest-plugins/
lrwxrwxrwx 1 boerre boerre 36 ođđj  4 11:02 xtdoc/sd/src/documentation/content/xdocs/future/proofing -> ../../../../../../../plan/proof/doc/
```

### cc57786a4ead8d901251ad5f895183ce38d754a1

```bash
❯ git log -n 1
commit 3ef13c4b78f54ad3015cdf2eee894eed9cf476e6 (HEAD)
Author: jaska <jaska@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Thu Jan 26 19:23:42 2012 +0000

    These are Komi-language abbreviations.

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@53313 c7155fb1-f0a7-4240-a2fc-2600b6f42f90

❯ find xtdoc/sd -type l |fgrep -v '.xml' |xargs ls -l
lrwxrwxrwx 1 boerre boerre 28 ođđj  4 11:02 xtdoc/sd/plugins -> ../../tools/forrest-plugins/
lrwxrwxrwx 1 boerre boerre 36 ođđj  4 11:02 xtdoc/sd/src/documentation/content/xdocs/future/proofing -> ../../../../../../../plan/proof/doc/
```

### 80ec13f927166e2b6af4563938fad8838594b442

```bash
❯ git log -n 1
commit 80ec13f927166e2b6af4563938fad8838594b442 (HEAD)
Author: sjur <sjur@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Tue Feb 14 13:25:24 2006 +0000

    Added a working XInclude and related parts for integrating future plan sections in the regular Forrest builds. It is now working as it should.

    It is commented out as the content isn't ready for publishing, but the structure could be reused by others if needed.


    git-svn-id: https://gtsvn.uit.no/langtech/trunk@5915 c7155fb1-f0a7-4240-a2fc-2600b6f42f90
```

ingen symbolske linker

### f07fde7fc5729edba1567542819b89f5f2cb945b

```bash
❯ git log -n 1
commit f07fde7fc5729edba1567542819b89f5f2cb945b (HEAD)
Author: marjaliisa <marjaliisa@c7155fb1-f0a7-4240-a2fc-2600b6f42f90>
Date:   Mon Jan 25 17:01:48 2016 +0000

    no need to give the plural form separately

    git-svn-id: https://gtsvn.uit.no/langtech/trunk@128667 c7155fb1-f0a7-4240-a2fc-2600b6f42f90
```

## Kataloger som må beholdes

* tools/forrest-plugins
* plan/proof
* tts/
* xtdoc/divvun
* xtdoc/sd

## Videreforedling med git filter-repo

```bash
git clone --mirror --no-local lt divvun-as-gitmirror
cd divvun-as-gitmirror
git filter-repo \
--path tools/forrest-plugins \
--path plan/proof \
--path tts/ \
--path xtdoc/divvun \
--path xtdoc/sd  \
--mailmap ../../websites_to_github/divvun.mailmap \
--message-callback ../clean_lang_history/replace_git_svn.py \
--replace-message ../clean_lang_history/replacements.txt
```

## Manuell bearbeidelse

```bash
cd ..
git clone divvun-as-gitmirror/ divvun-as-git
cd divvun-as-git
git rm -r plan
git commit -m"The plan directory is not needed anymore"
rm xtdoc/divvun/plugins
git mv tools/forrest-plugins/ xtdoc/divvun/plugins
git commit -m "Replace symlink with the real deal"
git mv xtdoc/divvun/* .
rm -rf xtdoc/
git commit -m"Move content of xtdoc/divvun to the root"
echo build > .gitignore
git add .gitignore
git commit -m"Ignore build directory"
```

## Rebase som beholder committerinfo

```bash
git -c rebase.instructionFormat='%s%nexec GIT_COMMITTER_DATE="%cD" GIT_COMMITTER_NAME="%aN" GIT_COMMITTER_EMAIL="%ae" git commit --amend --no-edit' rebase -i #hash
```
