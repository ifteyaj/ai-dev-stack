# Architecture

**Status:** Current\
**Last updated:** <YYYY-MM-DD>

## System context

<What the system does and who/what it talks to. A small diagram is welcome.>

```text
<client> -> <service> -> <datastore>
```

## Components

| Component | Responsibility | Depends on |
| --- | --- | --- |
| <name> | <single responsibility> | <component> |

## Data flow

1. <trigger>
2. <processing>
3. <persistence or response>

## Data model

| Entity | Key fields | Ownership |
| --- | --- | --- |
| <entity> | <fields> | <component> |

## Boundaries and invariants

- <What must never happen.>
- <Where validation occurs.>
- <Which component owns which state.>

## Failure modes

| Failure | Behaviour | Recovery |
| --- | --- | --- |
| <failure> | <observable behaviour> | <step> |

## Deployment

- <target, process, configuration>

## Known limitations

- <limitation and consequence>
