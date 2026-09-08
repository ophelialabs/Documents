## Move NTKB te Sec
When a **"Need-To-Know Basis" (NTKB)** policy is triggered or applied to a position, a `Job ID` or `Position ID` often changes or is masked in enterprise systems like [Workday](https://investor.workday.com/news-and-events/press-releases/news-details/2026/Workday-Accelerates-Retail-and-Hospitality-Momentum-with-New-Customer-Wins-and-AI-Innovations-for-the-Frontline/default.aspx) for two primary reasons: operational security and data compartmentalization.

## How NTKB and Workday Intersect
- **Role-Based Security**: Workday is designed so that employees only see the information required to do their jobs. A regular employee cannot see a coworker’s salary or personal file because they do not have a "need to know." 
- **Data Compartmentalization**: For organizations dealing with cleared personnel or sensitive projects, Workday acts as the digital gatekeeper. It ensures that personnel rosters, clearance tracking, and team structures are strictly partitioned.
- **Privilege Restrictions**: An administrative or security officer may have "Top Secret" clearance or high-level company privileges, but Workday configurations will still restrict them from viewing specific files unless their role explicitly demands it. [Spectraforce](https://spectraforce.com/careers/jobs/workday-hris-analyst-hcm-milwaukee-wisconsin-usa-483337)

Here is exactly why that identifier shifts within the system:

1. Obfuscation and Security Masking
- **Preventing Data Mining**: Standard Job IDs often follow a sequential pattern (e.g., JOB-2026-004). If a sensitive or cleared role uses a standard ID, bad actors or unauthorized employees could deduce the existence or nature of a classified project just by looking at the sequential gap or the department prefix.
- **Ghost or Proxy IDs**: When a role becomes restricted under NTKB, the system often automatically generates a new, randomized, or generic proxy Job ID. This hides the true nature, funding source, or location of the position from general system users.

2. Transitioning to a Restricted Security Group
- **Inheritance Rules**: In systems like Workday, a Job ID is tied to a specific "Job Profile" or "Position Restriction." When a role requires NTKB protocols, it must be moved into a completely different, restricted security group.
- **New System Object**: To cut off access from standard HR recruiters and general employees, the old, public-facing Job ID is closed out or deactivated, and a completely new Job ID object is created inside the secure silo.

3. Splitting Shared Positions
- **Isolating the Role**: If a single Job ID previously represented a generic pool of workers (e.g., five general "Systems Engineers"), and one of those spots is upgraded to a sensitive, NTKB-restricted project, that specific seat must be broken out. The system forces a new, unique Job ID to isolate that person's data and clearance tracking from the rest of the unclassified pool.

If you are navigating this system setup, let me know if you want to look into:
- How **Workday Position Restrictions** manage security overrides.
- The difference between a **Job Profile ID** and a **Position ID**.
- How **auditing logs** track changes when an ID is masked.