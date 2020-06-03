# SVC (Service Directory)

### parse_prolog_source.py
The Python Class `ParsePrologSource` accepts a list of prolog statements as input and returns a Tree structure as output.

e.g., Input:
```
parent("Bill", "John").
parent("Pam", "Bill").
father(Person, Father) :- parent(Person, Father), person(Father, "male").
mother(Person, Mother) :- parent(Person, Mother), person(Mother, "female").

person("Bill", "male").
person("Pam", "female").

father(person("Bill", "male"), person("John", "male")).
father(person("Pam", "male"), person("Bill", "male")).
father(person("Sue", "female"), person("Jim", "male")).
grandfather(Person, Grandfather) :-
    father(Father, Grandfather),
    father(Person, Father).
```

e.g., Output:<br />
`<class 'parser.PrologParser.PrologParser.P_textContext'>`

### build_prolog_ast.py
The Python Class `BuildPrologAST` accepts a Tree structure as input and returns an AST (python list) as ouptput.
e.g., Input:<br />
`<class 'parser.PrologParser.PrologParser.P_textContext'>`

e.g., Output: <br/>
```json
[
  {
    "uid": "268669b8-a522-11ea-b4e2-acde48001122",
    "type": "Root",
    "text": "Root",
    "results": [
      {
        "uid": "26866d00-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "parent(\"Bill\",\"John\").",
        "results": [
          {
            "uid": "26866df0-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "parent(\"Bill\",\"John\")",
            "results": [
              {
                "uid": "26866e40-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "parent",
                "results": []
              },
              {
                "uid": "26866efe-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "\"Bill\",\"John\"",
                "results": [
                  {
                    "uid": "26866f8a-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "\"Bill\",\"John\"",
                    "results": [
                      {
                        "uid": "26866fe4-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"Bill\"",
                        "results": [
                          {
                            "uid": "2686702a-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"Bill\"",
                            "results": []
                          }
                        ]
                      },
                      {
                        "uid": "2686707a-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "268670de-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"John\"",
                        "results": [
                          {
                            "uid": "26867124-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"John\"",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686723c-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "parent(\"Pam\",\"Bill\").",
        "results": [
          {
            "uid": "26867304-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "parent(\"Pam\",\"Bill\")",
            "results": [
              {
                "uid": "2686734a-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "parent",
                "results": []
              },
              {
                "uid": "268673f4-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "\"Pam\",\"Bill\"",
                "results": [
                  {
                    "uid": "26867476-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "\"Pam\",\"Bill\"",
                    "results": [
                      {
                        "uid": "268674c6-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"Pam\"",
                        "results": [
                          {
                            "uid": "2686750c-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"Pam\"",
                            "results": []
                          }
                        ]
                      },
                      {
                        "uid": "26867566-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "268675c0-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"Bill\"",
                        "results": [
                          {
                            "uid": "26867606-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"Bill\"",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "26867872-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "father(Person,Father):-parent(Person,Father),person(Father,\"male\").",
        "results": [
          {
            "uid": "26867a70-a522-11ea-b4e2-acde48001122",
            "type": "Binary",
            "text": "father(Person,Father):-parent(Person,Father),person(Father,\"male\")",
            "results": [
              {
                "uid": "26867b24-a522-11ea-b4e2-acde48001122",
                "type": "Compound",
                "text": "father(Person,Father)",
                "results": [
                  {
                    "uid": "26867b60-a522-11ea-b4e2-acde48001122",
                    "type": "Name",
                    "text": "father",
                    "results": []
                  },
                  {
                    "uid": "26867c00-a522-11ea-b4e2-acde48001122",
                    "type": "Termlist",
                    "text": "Person,Father",
                    "results": [
                      {
                        "uid": "26867c6e-a522-11ea-b4e2-acde48001122",
                        "type": "Binary",
                        "text": "Person,Father",
                        "results": [
                          {
                            "uid": "26867cb4-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Person",
                            "results": []
                          },
                          {
                            "uid": "26867d04-a522-11ea-b4e2-acde48001122",
                            "type": "Operator",
                            "text": ",",
                            "results": []
                          },
                          {
                            "uid": "26867d54-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Father",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "uid": "26867db8-a522-11ea-b4e2-acde48001122",
                "type": "Operator",
                "text": ":-",
                "results": []
              },
              {
                "uid": "26867f20-a522-11ea-b4e2-acde48001122",
                "type": "Binary",
                "text": "parent(Person,Father),person(Father,\"male\")",
                "results": [
                  {
                    "uid": "26867fca-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "parent(Person,Father)",
                    "results": [
                      {
                        "uid": "26868010-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "parent",
                        "results": []
                      },
                      {
                        "uid": "2686809c-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Person,Father",
                        "results": [
                          {
                            "uid": "26868114-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Person,Father",
                            "results": [
                              {
                                "uid": "26868150-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Person",
                                "results": []
                              },
                              {
                                "uid": "268681a0-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "268681e6-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Father",
                                "results": []
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "uid": "2686824a-a522-11ea-b4e2-acde48001122",
                    "type": "Operator",
                    "text": ",",
                    "results": []
                  },
                  {
                    "uid": "26868312-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "person(Father,\"male\")",
                    "results": [
                      {
                        "uid": "2686834e-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "person",
                        "results": []
                      },
                      {
                        "uid": "268683ee-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Father,\"male\"",
                        "results": [
                          {
                            "uid": "26868466-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Father,\"male\"",
                            "results": [
                              {
                                "uid": "268684ac-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Father",
                                "results": []
                              },
                              {
                                "uid": "268684f2-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "2686854c-a522-11ea-b4e2-acde48001122",
                                "type": "Atomic",
                                "text": "\"male\"",
                                "results": [
                                  {
                                    "uid": "26868592-a522-11ea-b4e2-acde48001122",
                                    "type": "DQS",
                                    "text": "\"male\"",
                                    "results": []
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "268687f4-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "mother(Person,Mother):-parent(Person,Mother),person(Mother,\"female\").",
        "results": [
          {
            "uid": "268689f2-a522-11ea-b4e2-acde48001122",
            "type": "Binary",
            "text": "mother(Person,Mother):-parent(Person,Mother),person(Mother,\"female\")",
            "results": [
              {
                "uid": "26868a9c-a522-11ea-b4e2-acde48001122",
                "type": "Compound",
                "text": "mother(Person,Mother)",
                "results": [
                  {
                    "uid": "26868ae2-a522-11ea-b4e2-acde48001122",
                    "type": "Name",
                    "text": "mother",
                    "results": []
                  },
                  {
                    "uid": "26868b6e-a522-11ea-b4e2-acde48001122",
                    "type": "Termlist",
                    "text": "Person,Mother",
                    "results": [
                      {
                        "uid": "26868bdc-a522-11ea-b4e2-acde48001122",
                        "type": "Binary",
                        "text": "Person,Mother",
                        "results": [
                          {
                            "uid": "26868c18-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Person",
                            "results": []
                          },
                          {
                            "uid": "26868c68-a522-11ea-b4e2-acde48001122",
                            "type": "Operator",
                            "text": ",",
                            "results": []
                          },
                          {
                            "uid": "26868cae-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Mother",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "uid": "26868d12-a522-11ea-b4e2-acde48001122",
                "type": "Operator",
                "text": ":-",
                "results": []
              },
              {
                "uid": "26868e7a-a522-11ea-b4e2-acde48001122",
                "type": "Binary",
                "text": "parent(Person,Mother),person(Mother,\"female\")",
                "results": [
                  {
                    "uid": "26868f24-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "parent(Person,Mother)",
                    "results": [
                      {
                        "uid": "26868f6a-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "parent",
                        "results": []
                      },
                      {
                        "uid": "26868ff6-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Person,Mother",
                        "results": [
                          {
                            "uid": "2686906e-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Person,Mother",
                            "results": [
                              {
                                "uid": "268690aa-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Person",
                                "results": []
                              },
                              {
                                "uid": "268690fa-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "26869140-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Mother",
                                "results": []
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "uid": "268691a4-a522-11ea-b4e2-acde48001122",
                    "type": "Operator",
                    "text": ",",
                    "results": []
                  },
                  {
                    "uid": "2686926c-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "person(Mother,\"female\")",
                    "results": [
                      {
                        "uid": "268692b2-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "person",
                        "results": []
                      },
                      {
                        "uid": "26869348-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Mother,\"female\"",
                        "results": [
                          {
                            "uid": "268693ca-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Mother,\"female\"",
                            "results": [
                              {
                                "uid": "26869406-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Mother",
                                "results": []
                              },
                              {
                                "uid": "26869456-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "268694b0-a522-11ea-b4e2-acde48001122",
                                "type": "Atomic",
                                "text": "\"female\"",
                                "results": [
                                  {
                                    "uid": "268694f6-a522-11ea-b4e2-acde48001122",
                                    "type": "DQS",
                                    "text": "\"female\"",
                                    "results": []
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686960e-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "person(\"Bill\",\"male\").",
        "results": [
          {
            "uid": "268696d6-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "person(\"Bill\",\"male\")",
            "results": [
              {
                "uid": "26869712-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "person",
                "results": []
              },
              {
                "uid": "268697bc-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "\"Bill\",\"male\"",
                "results": [
                  {
                    "uid": "26869848-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "\"Bill\",\"male\"",
                    "results": [
                      {
                        "uid": "26869898-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"Bill\"",
                        "results": [
                          {
                            "uid": "268698d4-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"Bill\"",
                            "results": []
                          }
                        ]
                      },
                      {
                        "uid": "26869924-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "2686997e-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"male\"",
                        "results": [
                          {
                            "uid": "268699c4-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"male\"",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "26869ad2-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "person(\"Pam\",\"female\").",
        "results": [
          {
            "uid": "26869b9a-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "person(\"Pam\",\"female\")",
            "results": [
              {
                "uid": "26869bd6-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "person",
                "results": []
              },
              {
                "uid": "26869c80-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "\"Pam\",\"female\"",
                "results": [
                  {
                    "uid": "26869d0c-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "\"Pam\",\"female\"",
                    "results": [
                      {
                        "uid": "26869d52-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"Pam\"",
                        "results": [
                          {
                            "uid": "26869d98-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"Pam\"",
                            "results": []
                          }
                        ]
                      },
                      {
                        "uid": "26869de8-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "26869e42-a522-11ea-b4e2-acde48001122",
                        "type": "Atomic",
                        "text": "\"female\"",
                        "results": [
                          {
                            "uid": "26869e88-a522-11ea-b4e2-acde48001122",
                            "type": "DQS",
                            "text": "\"female\"",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686a090-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "father(person(\"Bill\",\"male\"),person(\"John\",\"male\")).",
        "results": [
          {
            "uid": "2686a252-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "father(person(\"Bill\",\"male\"),person(\"John\",\"male\"))",
            "results": [
              {
                "uid": "2686a298-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "father",
                "results": []
              },
              {
                "uid": "2686a432-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "person(\"Bill\",\"male\"),person(\"John\",\"male\")",
                "results": [
                  {
                    "uid": "2686a5ae-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "person(\"Bill\",\"male\"),person(\"John\",\"male\")",
                    "results": [
                      {
                        "uid": "2686a66c-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"Bill\",\"male\")",
                        "results": [
                          {
                            "uid": "2686a6b2-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686a752-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"Bill\",\"male\"",
                            "results": [
                              {
                                "uid": "2686a7de-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"Bill\",\"male\"",
                                "results": [
                                  {
                                    "uid": "2686a82e-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"Bill\"",
                                    "results": [
                                      {
                                        "uid": "2686a874-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"Bill\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686a8c4-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686a91e-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"male\"",
                                    "results": [
                                      {
                                        "uid": "2686a964-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"male\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "uid": "2686a9c8-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "2686aa9a-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"John\",\"male\")",
                        "results": [
                          {
                            "uid": "2686aad6-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686ab80-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"John\",\"male\"",
                            "results": [
                              {
                                "uid": "2686ac02-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"John\",\"male\"",
                                "results": [
                                  {
                                    "uid": "2686ac52-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"John\"",
                                    "results": [
                                      {
                                        "uid": "2686ac98-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"John\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686ace8-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686ad42-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"male\"",
                                    "results": [
                                      {
                                        "uid": "2686ad88-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"male\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686afa4-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "father(person(\"Pam\",\"male\"),person(\"Bill\",\"male\")).",
        "results": [
          {
            "uid": "2686b15c-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "father(person(\"Pam\",\"male\"),person(\"Bill\",\"male\"))",
            "results": [
              {
                "uid": "2686b1a2-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "father",
                "results": []
              },
              {
                "uid": "2686b332-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "person(\"Pam\",\"male\"),person(\"Bill\",\"male\")",
                "results": [
                  {
                    "uid": "2686b4ae-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "person(\"Pam\",\"male\"),person(\"Bill\",\"male\")",
                    "results": [
                      {
                        "uid": "2686b576-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"Pam\",\"male\")",
                        "results": [
                          {
                            "uid": "2686b5b2-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686b65c-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"Pam\",\"male\"",
                            "results": [
                              {
                                "uid": "2686b6de-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"Pam\",\"male\"",
                                "results": [
                                  {
                                    "uid": "2686b72e-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"Pam\"",
                                    "results": [
                                      {
                                        "uid": "2686b774-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"Pam\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686b7c4-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686b81e-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"male\"",
                                    "results": [
                                      {
                                        "uid": "2686b85a-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"male\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "uid": "2686b8be-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "2686b99a-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"Bill\",\"male\")",
                        "results": [
                          {
                            "uid": "2686b9d6-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686ba76-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"Bill\",\"male\"",
                            "results": [
                              {
                                "uid": "2686bb02-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"Bill\",\"male\"",
                                "results": [
                                  {
                                    "uid": "2686bb52-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"Bill\"",
                                    "results": [
                                      {
                                        "uid": "2686bb98-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"Bill\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686bbe8-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686bc42-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"male\"",
                                    "results": [
                                      {
                                        "uid": "2686bc88-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"male\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686bea4-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "father(person(\"Sue\",\"female\"),person(\"Jim\",\"male\")).",
        "results": [
          {
            "uid": "2686c05c-a522-11ea-b4e2-acde48001122",
            "type": "Compound",
            "text": "father(person(\"Sue\",\"female\"),person(\"Jim\",\"male\"))",
            "results": [
              {
                "uid": "2686c098-a522-11ea-b4e2-acde48001122",
                "type": "Name",
                "text": "father",
                "results": []
              },
              {
                "uid": "2686c232-a522-11ea-b4e2-acde48001122",
                "type": "Termlist",
                "text": "person(\"Sue\",\"female\"),person(\"Jim\",\"male\")",
                "results": [
                  {
                    "uid": "2686c3a4-a522-11ea-b4e2-acde48001122",
                    "type": "Binary",
                    "text": "person(\"Sue\",\"female\"),person(\"Jim\",\"male\")",
                    "results": [
                      {
                        "uid": "2686c46c-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"Sue\",\"female\")",
                        "results": [
                          {
                            "uid": "2686c4a8-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686c552-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"Sue\",\"female\"",
                            "results": [
                              {
                                "uid": "2686c5d4-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"Sue\",\"female\"",
                                "results": [
                                  {
                                    "uid": "2686c624-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"Sue\"",
                                    "results": [
                                      {
                                        "uid": "2686c66a-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"Sue\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686c6ba-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686c714-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"female\"",
                                    "results": [
                                      {
                                        "uid": "2686c75a-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"female\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "uid": "2686c7be-a522-11ea-b4e2-acde48001122",
                        "type": "Operator",
                        "text": ",",
                        "results": []
                      },
                      {
                        "uid": "2686c890-a522-11ea-b4e2-acde48001122",
                        "type": "Compound",
                        "text": "person(\"Jim\",\"male\")",
                        "results": [
                          {
                            "uid": "2686c8cc-a522-11ea-b4e2-acde48001122",
                            "type": "Name",
                            "text": "person",
                            "results": []
                          },
                          {
                            "uid": "2686c976-a522-11ea-b4e2-acde48001122",
                            "type": "Termlist",
                            "text": "\"Jim\",\"male\"",
                            "results": [
                              {
                                "uid": "2686ca02-a522-11ea-b4e2-acde48001122",
                                "type": "Binary",
                                "text": "\"Jim\",\"male\"",
                                "results": [
                                  {
                                    "uid": "2686ca48-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"Jim\"",
                                    "results": [
                                      {
                                        "uid": "2686ca8e-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"Jim\"",
                                        "results": []
                                      }
                                    ]
                                  },
                                  {
                                    "uid": "2686cade-a522-11ea-b4e2-acde48001122",
                                    "type": "Operator",
                                    "text": ",",
                                    "results": []
                                  },
                                  {
                                    "uid": "2686cb38-a522-11ea-b4e2-acde48001122",
                                    "type": "Atomic",
                                    "text": "\"male\"",
                                    "results": [
                                      {
                                        "uid": "2686cb7e-a522-11ea-b4e2-acde48001122",
                                        "type": "DQS",
                                        "text": "\"male\"",
                                        "results": []
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "uid": "2686cdcc-a522-11ea-b4e2-acde48001122",
        "type": "Clause",
        "text": "grandfather(Person,Grandfather):-father(Father,Grandfather),father(Person,Father).",
        "results": [
          {
            "uid": "2686cfc0-a522-11ea-b4e2-acde48001122",
            "type": "Binary",
            "text": "grandfather(Person,Grandfather):-father(Father,Grandfather),father(Person,Father)",
            "results": [
              {
                "uid": "2686d06a-a522-11ea-b4e2-acde48001122",
                "type": "Compound",
                "text": "grandfather(Person,Grandfather)",
                "results": [
                  {
                    "uid": "2686d0b0-a522-11ea-b4e2-acde48001122",
                    "type": "Name",
                    "text": "grandfather",
                    "results": []
                  },
                  {
                    "uid": "2686d13c-a522-11ea-b4e2-acde48001122",
                    "type": "Termlist",
                    "text": "Person,Grandfather",
                    "results": [
                      {
                        "uid": "2686d1b4-a522-11ea-b4e2-acde48001122",
                        "type": "Binary",
                        "text": "Person,Grandfather",
                        "results": [
                          {
                            "uid": "2686d1f0-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Person",
                            "results": []
                          },
                          {
                            "uid": "2686d240-a522-11ea-b4e2-acde48001122",
                            "type": "Operator",
                            "text": ",",
                            "results": []
                          },
                          {
                            "uid": "2686d286-a522-11ea-b4e2-acde48001122",
                            "type": "Variable",
                            "text": "Grandfather",
                            "results": []
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "uid": "2686d2ea-a522-11ea-b4e2-acde48001122",
                "type": "Operator",
                "text": ":-",
                "results": []
              },
              {
                "uid": "2686d448-a522-11ea-b4e2-acde48001122",
                "type": "Binary",
                "text": "father(Father,Grandfather),father(Person,Father)",
                "results": [
                  {
                    "uid": "2686d4fc-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "father(Father,Grandfather)",
                    "results": [
                      {
                        "uid": "2686d538-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "father",
                        "results": []
                      },
                      {
                        "uid": "2686d5c4-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Father,Grandfather",
                        "results": [
                          {
                            "uid": "2686d63c-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Father,Grandfather",
                            "results": [
                              {
                                "uid": "2686d678-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Father",
                                "results": []
                              },
                              {
                                "uid": "2686d6c8-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "2686d70e-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Grandfather",
                                "results": []
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "uid": "2686d772-a522-11ea-b4e2-acde48001122",
                    "type": "Operator",
                    "text": ",",
                    "results": []
                  },
                  {
                    "uid": "2686d826-a522-11ea-b4e2-acde48001122",
                    "type": "Compound",
                    "text": "father(Person,Father)",
                    "results": [
                      {
                        "uid": "2686d86c-a522-11ea-b4e2-acde48001122",
                        "type": "Name",
                        "text": "father",
                        "results": []
                      },
                      {
                        "uid": "2686d8f8-a522-11ea-b4e2-acde48001122",
                        "type": "Termlist",
                        "text": "Person,Father",
                        "results": [
                          {
                            "uid": "2686d966-a522-11ea-b4e2-acde48001122",
                            "type": "Binary",
                            "text": "Person,Father",
                            "results": [
                              {
                                "uid": "2686d9ac-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Person",
                                "results": []
                              },
                              {
                                "uid": "2686d9f2-a522-11ea-b4e2-acde48001122",
                                "type": "Operator",
                                "text": ",",
                                "results": []
                              },
                              {
                                "uid": "2686da42-a522-11ea-b4e2-acde48001122",
                                "type": "Variable",
                                "text": "Father",
                                "results": []
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
```