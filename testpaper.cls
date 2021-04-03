\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{testpaper}[2021/04/03 Test papers]

\LoadClass{article}

\RequirePackage{ctex}
\RequirePackage{ifthen}
\RequirePackage[hmargin=1.25in,vmargin=1in]{geometry}
\RequirePackage{lastpage}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{comment}
\RequirePackage{mdframed}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{ragged2e}

\InputIfFileExists{\jobname.sum}{}{}

\newwrite\pointssummation
\immediate\openout\pointssummation=\jobname.sum

%\newcounter{part}
%\newcounter{section}
\newcounter{problem}
\newcounter{subproblem}

\newcounter{partpoints}
\newcounter{sectionpoints}
\newcounter{sectionproblems}
\newcounter{pointssum}
\newcounter{problemssum}

\newcommand{\writepartpoints}{
  \immediate\write\pointssummation{\unexpanded{\newcommand}}
  \immediate\write\pointssummation{{\string\part\roman{part}points}}
  \immediate\write\pointssummation{{\thepartpoints}}
}
\newcommand{\writesectionpoints}{
  \immediate\write\pointssummation{\unexpanded{\newcommand}}
  \immediate\write\pointssummation{{\string\section\roman{section}points}}
  \immediate\write\pointssummation{{\thesectionpoints}}
}
\newcommand{\writesectionproblems}{
  \immediate\write\pointssummation{\unexpanded{\newcommand}}
  \immediate\write\pointssummation{{\string\section\roman{section}problems}}
  \immediate\write\pointssummation{{\thesectionproblems}}
}

\newcommand{\currentpartpoints}{\ifthenelse{\isundefined{\csname part\roman{part}points\endcsname}}{?}{\csname part\roman{part}points\endcsname}}
\newcommand{\currentsectionpoints}{\ifthenelse{\isundefined{\csname section\roman{section}points\endcsname}}{?}{\csname section\roman{section}points\endcsname}}
\newcommand{\currentsectionproblems}{\ifthenelse{\isundefined{\csname section\roman{section}problems\endcsname}}{?}{\csname section\roman{section}problems\endcsname}}
\newcommand{\totalpoints}{\ifthenelse{\isundefined{\totalpointsout}}{?}{\totalpointsout}}
\newcommand{\totalproblems}{\ifthenelse{\isundefined{\totalproblemsout}}{?}{\totalproblemsout}}

\newcommand{\parttitle}[1]{
  \begin{center}
    \bfseries \large
    第\chinese{part}部分：#1（\currentpartpoints 分）
  \end{center}
}

\newcommand{\sectiontitle}[1]{
  \noindent\textbf{\chinese{section}、#1（\currentsectionproblems 题，共 \currentsectionpoints 分）}\par
}

\newcommand{\problemtitle}[1]{
  \par\noindent\textbf{\arabic{problem}.} （#1 分）
}

\renewcommand{\part}[1]{
  \ifthenelse{\arabic{part} > 0}{\writepartpoints}{}
  \stepcounter{part}
  \setcounter{partpoints}{0}
  \parttitle{#1}
}

\renewcommand{\section}[1]{
  \ifthenelse{\arabic{section} > 0}{\writesectionpoints}{}
  \ifthenelse{\arabic{section} > 0}{\writesectionproblems}{}
  \stepcounter{section}
  \setcounter{sectionpoints}{0}
  \setcounter{sectionproblems}{0}
  \begin{flushleft}
    \sectiontitle{#1}
  \end{flushleft}
}

\newcommand{\problem}[1]{
  \stepcounter{problem}
  \addtocounter{partpoints}{#1}
  \addtocounter{sectionpoints}{#1}
  \addtocounter{pointssum}{#1}
  \stepcounter{sectionproblems}
  \stepcounter{problemssum}
  \problemtitle{#1}
}

\AtEndDocument{
  \ifthenelse{\arabic{part} > 0}{\writepartpoints}{}
  \ifthenelse{\arabic{section} > 0}{\writesectionpoints}{}
  \ifthenelse{\arabic{section} > 0}{\writesectionproblems}{}
  \immediate\write\pointssummation{\unexpanded{\newcommand}}
  \immediate\write\pointssummation{{\string\totalpointsout}}
  \immediate\write\pointssummation{{\thepointssum}}
  \immediate\write\pointssummation{\unexpanded{\newcommand}}
  \immediate\write\pointssummation{{\string\totalproblemsout}}
  \immediate\write\pointssummation{{\theproblemssum}}
  \immediate\closeout\pointssummation
}

\setlength{\parskip}{0.5ex}

\newcommand{\subproblemindent}{2ex}

\newenvironment{subproblems}{
  \setcounter{subproblem}{0}
}{}

\newcommand{\subproblem}{\stepcounter{subproblem}\par\textbf{(\thesubproblem)} }

\newcommand{\source}[1]{
  \hfill\emph{(#1)}
}

\renewcommand{\maketitle}{
  \thispagestyle{firstpage}
  \begin{center}
    \Large \@title
    
    \vspace{0.2em} \large \@author
    
    \large \@date
  \end{center}
  \begin{center}
    试卷共 \pageref*{LastPage} 页，\totalproblems 题，满分 \totalpoints 分。
  \end{center}
}

\pagestyle{fancy}
\fancyhead[L,R]{}
\fancyhead[C]{\@title}
\fancyfoot[L,R]{}
\fancyfoot[C]{第 \thepage 页，共 \pageref*{LastPage} 页}

\fancypagestyle{firstpage}{
  \renewcommand{\headrulewidth}{0pt}
  \fancyhead[L,R,C]{}
  \fancyfoot[L,R]{}
  \fancyfoot[C]{第 \thepage 页，共 \pageref*{LastPage} 页}
}

\newboolean{enableanswers}
\setboolean{enableanswers}{false}

\newmdenv[linewidth=0.5pt,backgroundcolor=white]{answerbox}

\newcommand{\answerfield}[2]{
  \begin{answerbox}
    #2
    \vspace{#1}
  \end{answerbox}
}

\excludecomment{answer}

\DeclareOption{answers}{
  \setboolean{enableanswers}{true}
  \renewcommand{\answerfield}[2]{}
  \renewenvironment{answer}{
    \begin{answerbox}
  }{
    \end{answerbox}
  }
}

\ProcessOptions
