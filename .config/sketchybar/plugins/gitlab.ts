type MergeRequest = {
  title: string;
  iid: number;
  project_id: number;
};

type ApprovalResponse = {
  approved_by: { user: { username: string } }[];
};

const HEADERS = {
  "Private-Token": process.env.API_TOKEN,
  "Content-Type": "application/json",
};

async function fetchJson<T>(url: string): Promise<T> {
  const res = await fetch(url, { headers: HEADERS });
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} - ${url}`);
  }
  return res.json();
}

async function getOpenMergeRequests(userId: number): Promise<MergeRequest[]> {
  const url = `${process.env.GITLAB_URL}/api/v4/merge_requests?author_id=${userId}&state=opened&scope=all&wip=no&per_page=100`;
  const mrs = await fetchJson<MergeRequest[]>(url);

  return mrs;
}

async function getApprovals(projectId: number, mrIid: number): Promise<number> {
  const url = `${process.env.GITLAB_URL}/api/v4/projects/${projectId}/merge_requests/${mrIid}/approvals`;

  try {
    const data = await fetchJson<ApprovalResponse>(url);
    return data.approved_by?.length || 0;
  } catch (err) {
    console.error(`Fehler bei MR!${mrIid}:`, (err as Error).message);
    return 0;
  }
}

async function main() {
  const result = { approved: 0, notApproved: 0 };
  const mrs = await getOpenMergeRequests(process.env.USERID);

  await Promise.all(
    mrs.map(async (mr) => {
      const approvals = await getApprovals(mr.project_id, mr.iid);

      if (approvals > 1) {
        result.approved = result.approved + 1;
      } else {
        result.notApproved = result.notApproved + 1;
      }
    })
  );

  console.log(`${result.approved} ${result.notApproved} ${result.approved}`);
}

main();
