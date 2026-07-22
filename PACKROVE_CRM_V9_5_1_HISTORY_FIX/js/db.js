(function(){
  const cfg=window.PACKROVE_CONFIG||{};
  const prefix=cfg.LOCAL_STORAGE_PREFIX||"packrove_";
  const configured=Boolean(cfg.SUPABASE_URL&&cfg.SUPABASE_PUBLISHABLE_KEY);
  const client=configured?window.supabase.createClient(cfg.SUPABASE_URL,cfg.SUPABASE_PUBLISHABLE_KEY):null;
  const tables=["customers","timeline","quotations","pi_documents","orders","shipments"];
  const key=t=>prefix+t;
  const clone=x=>JSON.parse(JSON.stringify(x));
  function localLoad(t){const raw=localStorage.getItem(key(t));if(raw)return JSON.parse(raw);let initial=[];if(t==="customers")initial=clone(window.PACKROVE_SEED_CUSTOMERS||[]);localStorage.setItem(key(t),JSON.stringify(initial));return initial}
  function localSave(t,data){localStorage.setItem(key(t),JSON.stringify(data))}
  const uuid=()=>crypto.randomUUID?crypto.randomUUID():`local-${Date.now()}-${Math.random().toString(16).slice(2)}`;
  async function select(t,opts={}){if(!configured){let data=localLoad(t);if(opts.orderBy)data.sort((a,b)=>String(b[opts.orderBy]||'').localeCompare(String(a[opts.orderBy]||'')));return clone(data)}let q=client.from(t).select(opts.select||'*');if(opts.orderBy)q=q.order(opts.orderBy,{ascending:opts.ascending??false});const {data,error}=await q;if(error)throw error;return data||[]}
  async function insert(t,row){if(!configured){const data=localLoad(t);const rec={id:row.id||uuid(),...row,created_at:row.created_at||new Date().toISOString(),updated_at:new Date().toISOString()};data.push(rec);localSave(t,data);return clone(rec)}const {data,error}=await client.from(t).insert(row).select().single();if(error)throw error;return data}
  async function update(t,id,patch){if(!configured){const data=localLoad(t);const i=data.findIndex(x=>String(x.id)===String(id));if(i<0)throw new Error('记录不存在');data[i]={...data[i],...patch,updated_at:new Date().toISOString()};localSave(t,data);return clone(data[i])}const {data,error}=await client.from(t).update(patch).eq('id',id).select().single();if(error)throw error;return data}
  async function remove(t,id){if(!configured){let data=localLoad(t);data=data.filter(x=>String(x.id)!==String(id));localSave(t,data);return true}const {error}=await client.from(t).delete().eq('id',id);if(error)throw error;return true}
  async function upsertCustomer(row){const all=await select('customers');const found=all.find(x=>String(x.name).trim().toLowerCase()===String(row.name).trim().toLowerCase());return found?update('customers',found.id,row):insert('customers',row)}
  async function session(){if(!configured)return {user:{email:'local@packrove'}};const {data}=await client.auth.getSession();return data.session}
  async function signIn(email,password){const {data,error}=await client.auth.signInWithPassword({email,password});if(error)throw error;return data}
  async function signUp(email,password){const {data,error}=await client.auth.signUp({email,password});if(error)throw error;return data}
  async function signOut(){if(configured)await client.auth.signOut()}
  function resetLocal(){tables.forEach(t=>localStorage.removeItem(key(t)))}
  window.PackroveDB={configured,client,select,insert,update,remove,upsertCustomer,session,signIn,signUp,signOut,resetLocal};
})();