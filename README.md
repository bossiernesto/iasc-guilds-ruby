# Guilds y Ractors

> Version utilizada: ruby 3.1.0dev (2021-04-26T12:15:06Z master 5219b4ddb4) [x86_64-linux]


```
Cuidado: esta seccion usa codigo que esta actualmente en fase experimental. El mismo puede llegar a quedar bastante deprecado
```

Ejemplos simples de ractor y un ejemplo final con coomunicacion entre procesos utilizando una cola de mensajes con redis.

```
Ractor r
                 ┌───────────────────────────────────────────┐
                 │ incoming                         outgoing │
                 │ port                                 port │
   r.send(obj) ->│->[incoming queue]     Ractor.yield(obj) ->│-> r.take
                 │                |                          │
                 │                v                          │
                 │           Ractor.receive                  │
                 └───────────────────────────────────────────┘


Connection example: r2.send obj on r1、Ractor.receive on r2
  ┌────┐     ┌────┐
  │ r1 ├────►│ r2 │
  └────┘     └────┘


Connection example: Ractor.yield(obj) on r1, r1.take on r2
  ┌────┐     ┌────┐
  │ r1 ├────►│ r2 │
  └────┘     └────┘

Connection example: Ractor.yield(obj) on r1 and r2,
                    and waiting for both simultaneously by Ractor.select(r1, r2)

  ┌────┐
  │ r1 ├──────┐
  └────┘      │
              ├────► Ractor.select(r1, r2)
  ┌────┐      │
  │ r2 ├──────┘
  └────┘
```

Statuses of a Ractor

```
   ┌───────────────────────────────┐
   │                               │
   │                               │
   │             Created           │
   │                               │                             General Note: status is protected by VM lock (global state)
   │                               │
   └────────────────┬──────────────┘
                    │
                    │
                    │
                    │
                    │
                    │   Ready to run
                    │
                    ▼
 ┌──────────────────┬──────────────────┐ Enter into the VM
─┴──────────────────┼──────────────────┴──
                    │
                    │
    ┌───────────────▼─────────────────┐
    │                                 │
    │                                 │
    │           Blocking              ◄────────────┐
    │                                 │            ├────── all threads blocked
    │                                 │            │
    └───────────────┬─────────────────┘            │
                    │                              │
                    │                              │
                    │                              │
    ┌───────────────▼─────────────────┐            │
    │                                 │            │
    │                                 │            │
    │                                 ├────────────┘
    │           Running               │
    │                                 │
    │                                 │
    └──────────────┬──────────────────┘
                   │
                   │
                   │
                   ▼
  ───────────────────────────────────────
                                           removed from vm->reactor
```